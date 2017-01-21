class DatabaseType
	attr_reader :name, :engine, :port, :cred

	private

	def initialize(options = {})
		@name = options[:name]
		@engine = options[:engine] || @name
		@port = options[:port]
		@cred = options[:cred] || {}
	end

	class << self
		def all
			ObjectSpace.each_object(self).to_a
		end
	end
end

class DatabaseType
	FIREBIRD = new(
		name: :firebird, 
		port: 3050,
		cred: {
			user: { env: 'ISC_USER' },
			pass: { env: 'ISC_PASSWD' }
		}
	)
	MONGODB = new(
		name: :mongodb,
		engine: :mongo,
		port: 27017,
	)
	MSSQL = new(
		name: :mssql,
		port: 1433,
		cred: {
			user: { default: 'sa' },
			pass: { env: 'SA_PASS' }
		}
	)
	MYSQL = new(
		name: :mysql,
		engine: :server,
		port: 3306,
		cred: {
			user: { default: 'root' },
			pass: { env: 'MYSQL_ROOT_PASSWORD' }
		}
	)
	ORACLE = new(
		name: :oracle,
		port: 1521,
		cred: {
			user: { default: 'system' },
			pass: { default: 'oracle' }
		}
	)
	POSTGRESQL = new(
		name: :postgres,
		engine: :pgsql,
		port: 5432,
		cred: {
			user: {
				env: 'POSTGRES_USER',
				default: 'postgres'
			},
			pass: { env: 'POSTGRES_PASS' }
		}
	)
end
