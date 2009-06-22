class Audit < ActiveRecord::Base
  belongs_to(:auditable, :polymorphic => true)
  belongs_to :user
end