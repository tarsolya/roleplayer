require 'generators/roleplayer'

module Roleplayer #:nodoc:#
  module Generators #:nodoc:#
    class MigrationGenerator < Base #:nodoc:
      include Rails::Generators::Migration
      
      def create_migration_file
        migration_template "migration.rb", "db/migrate/roleplayer_migration"
      end
      
    end
  end
end
