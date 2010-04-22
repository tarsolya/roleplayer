require 'active_support/core_ext'
require 'active_record'

# Simple role management implementation for ActiveRecord models.
module Roleplayer
  
  #:stopdoc:
  DEFAULT_OPTIONS = {
  }.freeze
  #:startdoc:
  
  attr_accessor_with_default( :options, {}.merge( Roleplayer::DEFAULT_OPTIONS ) )
  
  # Defines a model as a roleplayer.
  #
  # === Associations
  #
  # * +roles+ - Contains the roles assigned to the model instance.
  # * +role_assignments+ - Polymorphic join model for roles.
  #
  # === Scopes
  #
  # * <tt>with_any_roles( *args )</tt> - Scope for filtering results based on a list of roles
  #   using the OR operator.
  #   
  # * <tt>with_all_roles( *args )</tt> - Scope for filtering results based on a list of roles
  #   using the AND operator.
  #
  # === Examples
  #
  #   Foo.find(1).roles                                 #=> [ :editor ]
  #   Foo.find(2).roles                                 #=> [ :admin ]
  #   Foo.find(3).roles                                 #=> [ :editor, :admin ]
  #
  #   Foo.with_any_roles( :editor, :admin )             #=> [ <Foo:1 ...>, <Foo:2 ...>, <Foo:3 ...> ]
  #   Foo.with_any_roles( :editor )                     #=> [ <Foo:1 ...>, <Foo:3 ...> ]
  #   Foo.with_all_roles( :editor, :admin )             #=> [ <Foo:3 ...> ]
  #
  # Scopes are chainable:
  #
  #   Foo.with_any_roles( :editor, :admin ).limit( 1 )  #=> [ <Foo:1 ...> ]
  #
  def roleplayer( *args )
    
    self.options.merge!( args.extract_options! )
    
    has_many :role_assignments, :class_name => 'RoleAssignment', :as => :assignee, :dependent => :destroy
    has_many :roles, :through => :role_assignments

    scope :with_any_roles, lambda { |*args|
      joins( :roles ).
      where( "roles.name IN (?) ", args.collect { |arg| arg.to_s } )
    }
    
    scope :with_all_roles, lambda { |*args|
      joins(:roles).
      where( "roles.name IN (?) ", args.collect { |arg| arg.to_s } ).
      group( "accounts.id" ).
      having( "count(*) = ?", args.size )
    }

    include Roleplayer::InstanceMethods
    
  end
  
  module InstanceMethods
    
    # Compatibility method for +declarative_authorization+, which expect roles
    # from a model instance as a list of symbols.
    def role_symbols
      roles.map { |r| r.name.to_sym }
    end
    
    # Returns true, if the model instance has +role+ assigned to it.
    #
    # === Examples
    #
    #   foo.roles #=> [ :admin, :vip ]
    #
    #   foo.has_role? ( :admin )        #=> true
    #   foo.has_role? ( "vip" )         #=> true
    #   foo.has_role? ( :invited )      #=> false
    #   
    def has_role?( role = nil )
      return false if role.nil?
      roles.exists?( :name => role.to_s )
    end
    
    # Assigns a list of roles to the model instance.
    # You can use any combination of arguments: they will be flattened
    # and only previously existing roles will be added.
    #
    # === Examples
    #   
    #   foo.add_roles( :admin )                               #=> [ :admin ]
    #   foo.add_roles( :admin, :editor )                      #=> [ :admin, :editor ]
    #   
    # When the <tt>:invited</tt> role doesn't exist:
    #   
    #   foo.add_roles( [:admin, :editor], [:invited, :vip] )  #=> [ :admin, :editor, :vip ]
    #   
    def add_roles( *args )
      args.flatten!
      args.each { |arg| roles.push( Role.find_by_name( arg.to_s ) ) if Role.valid?( arg ) }
    end
    
    # Delete a list of assigned roles from a model instance.
    # Same as +add_roles+, arguments will be flattened before performing the delete,
    # so you can pass multiple arguments at once for convenience.
    #
    # === Examples
    #
    #   foo.roles                                             #=> [ :admin, :editor, :vip ]
    #
    #   foo.delete_roles( :admin )                            #=> [ :editor, :vip ]
    #   foo.delete_roles( [ :editor ], [ :vip, :invited ] )   #=> []
    #
    def delete_roles( *args )
      args.flatten!
      args.each { |arg| roles.delete( Role.find_by_name( arg.to_s ) ) if has_role?( arg ) }
    end
    
    # Removes all roles from the model instance.
    #
    # === Examples
    #
    #   foo.roles         #=> [ :admin, :editor, :vip ]
    #
    #   foo.reset_roles!
    #   foo.roles         #=> []
    #
    def reset_roles!
      roles.clear
    end
    
  end
end

ActiveRecord::Base.class_eval { extend Roleplayer }
