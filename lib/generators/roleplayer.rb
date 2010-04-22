require 'rails/generators/base'
require 'rails/generators/migration'
require 'active_record'

module Roleplayer #:nodoc:
  module Generators #:nodoc:
    class Base < Rails::Generators::Base #:nodoc:
      include Rails::Generators::Migration
      
      def self.source_root
        @_roleplayer_source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'roleplayer', generator_name, 'templates'))
      end
      
      # Required interface for Rails::Generators::Migration
      def self.next_migration_number(dirname) #:nodoc:
        if ActiveRecord::Base.timestamped_migrations
          Time.now.utc.strftime("%Y%m%d%H%M%S")
        else
          "%.3d" % (current_migration_number(dirname) + 1)
        end
      end
      
    end
  end
end

    