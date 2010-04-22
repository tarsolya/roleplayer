# Role model definition.
class Role < ActiveRecord::Base
  
  has_many :assignments, :class_name => 'RoleAssignment'

  # Returns true if a role with +role_name+ exists.
  def self.valid? ( role_name = nil )
    return false if role_name.nil?
    self.exists?( :name => role_name.to_s )
  end
  
end
