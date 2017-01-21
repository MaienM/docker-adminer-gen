require './database_type'

class Container < Docker::Container
	# The environment variables
	ENV_NAME = 'ADMINER_NAME'
	ENV_TYPE = 'ADMINER_TYPE'
	ENV_HOST = 'ADMINER_HOST'
	ENV_PORT = 'ADMINER_PORT'
	ENV_USER = 'ADMINER_USER'
	ENV_PASS = 'ADMINER_PASS'
	ENV_DB = 'ADMINER_DATABASE'

	def name
		return env[ENV_NAME]
	end

	def type
		options = DatabaseType.all.map(&:name)
		if env.include?(ENV_TYPE)
			type = env[ENV_TYPE]
			return type if options.include?(type)
			fail "Invalid value for #{ENV_TYPE}: #{type}, allowed: #{options.join(', ')}"
		else
			types = ports.map { |p| DatabaseType.all.select { |dt| dt.port == p }.first }.compact
			return types.first if types.size == 1
			fail "Unable to determine database type automatically, please set #{ENV_TYPE} to one of: #{options.join(', ')}"
		end
	end

	def host
		return env[ENV_HOST] if env.include?(ENV_HOST)

		ips = info['NetworkSettings']['Networks'].map { |k, v| [k.downcase, v['IPAddress']] }.to_h
		return self.class.adminer.networks.map { |n| ips[n.downcase] }.compact.first
	end

	def networks
		return info['NetworkSettings'].keys
	end

	def ports
		return info['Ports'].map { |p| p['PrivatePort'] }
	end

	def port
		if env.include?(ENV_PORT)
			port = env[ENV_PORT].to_i
			return port if (1..65535).include?(port)
			fail "Invalid value for #{ENV_PORT}: port, must be in range 1-65535"
		else
			return type.port if ports.include?(type.port)
			fail "Unable to determine database port automatically, please set #{ENV_PORT}"
		end
	end

	def user
		return cred(:user)
	end

	def pass
		return cred(:pass)
	end

	def db
		return env[ENV_DB] || ''
	end

	def to_adminer
		return unless running?
		return unless adminer_enabled?
		return if special?

		puts "Found adminer enabled container with name #{name} (#{id})"
		data = {
			name: name,
			engine: type.engine,
			host: "#{host}:#{port}",
			username: user,
			password: pass,
			db: db,
		}
		puts "Contained database is #{type}, available at #{host}:#{port}"
		return data
	rescue => e
		puts e.message
	end

	def running?
		return json['State']['Running']
	end

	def special?
		return [self.class.current.id, self.class.adminer.id].include?(self.id)
	end

	def adminer_enabled?
		return env.include?(ENV_NAME)
	end

	private 

	def env
		return json['Config']['Env'].map { |e| e.split('=', 2) }.to_h
	end

	def cred(field)
		# Get the credentials definition for this field
		cred = type.cred[field] || {}

		# Get all environment variables that have to be check for this field
		vars = []
		vars << case field
			when :user then ENV_USER
			when :pass then ENV_PASS
			else fail "Invalid field #{field}"
		end
		vars << cred[:env]

		# Try to get the field using each of the variables, and fallback to the default value or empty
		vars.flatten.compact.each do |v|
			return env[v] if env.include?(v)
		end
		return cred[:default] || ''
	end

	class << self
		def current
			return get(ENV['HOSTNAME'])
		end

		def adminer
			# TODO
			return get(ENV['ADMINER_NAME'] || ENV['HOSTNAME'])
		end
	end
end
