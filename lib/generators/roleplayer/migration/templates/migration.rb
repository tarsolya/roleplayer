class RoleplayerMigration < ActiveRecord::Migration #:nodoc:
  
  def self.up
    
    # Role table
    create_table :roles do |t|
      t.string :name, :null => false
    end

    # Assignments table
    create_table :role_assignments do |t|
      t.references :role, :null => false
      t.references :assignee, :polymorphic => true, :null => false
    end
    
    # Create a unique index for fast lookups and for some ref. integrity
    add_index :role_assignments, 
              [ :role_id, :assignee_id, :assignee_type ],
              :unique => true, 
              :name => 'index_role_assigns_by_assignee'
    
  end
  
  def self.down
    drop_table :roles, :role_assignments
  end
  
end
