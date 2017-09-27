class DatabaseType
	attr_reader :name, :engine, :port, :fields

	private

	def initialize(options = {})
		@name = options[:name]
		@engine = options[:engine] || @name
		@port = options[:port]
		@fields = options[:fields] || {}
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
		fields: {
			user: { default: 'SYSDBA' },
			pass: {
				env: 'FIREBIRD_PASSWORD',
				default: 'masterkey'
			}
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
		fields: {
			user: { default: 'sa' },
			pass: { env: %w(SA_PASS SA_PASSWORD) }
		}
	)
	MYSQL = new(
		name: :mysql,
		engine: :server,
		port: 3306,
		fields: {
			user: {
				env: 'MYSQL_USER',
				default: 'root'
			},
			pass: { env: %w(MYSQL_PASSWORD MYSQL_ROOT_PASSWORD) },
			db: { env: 'MYSQL_DATABASE' }
		}
	)
	ORACLE = new(
		name: :oracle,
		port: 1521,
		fields: {
			user: { default: 'system' },
			pass: { default: 'oracle' }
		}
	)
	POSTGRESQL = new(
		name: :postgres,
		engine: :pgsql,
		port: 5432,
		fields: {
			user: {
				env: 'POSTGRES_USER',
				default: 'postgres'
			},
			pass: { env: 'POSTGRES_PASSWORD' },
			db: {
				env: %w(POSTGRES_DB POSTGRES_USER),
				default: 'postgres'
			}
		}
	)
end
