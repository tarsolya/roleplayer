# Polymorphic relationship model for assigning Role objects
# to the receiver models.
#
class RoleAssignment < ActiveRecord::Base

  # Make other end of the chain accessible through
  attr_accessible :role, :role_id, :assignee_id, :assignee_type

  belongs_to :role
  belongs_to :assignee, :polymorphic => true
  
  validates_presence_of :role_id, :assignee_id, :assignee_type

end
