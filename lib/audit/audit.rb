class Audit < ActiveRecord::Base
  belongs_to(:auditable, :polymorphic => true)
  belongs_to :user
  
  named_scope :created, :conditions => {:action => 'create'}
  named_scope :updated, :conditions => {:action => 'update'}
  named_scope :destroy, :conditions => {:action => 'destroy'}
end