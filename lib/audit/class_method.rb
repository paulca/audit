module AuditClassMethods
  def self.included(base) 
    base.extend AuditMethod
  end

  module AuditMethod
    def audit

      after_create :log_create_audit
      after_update :log_update_audit
      after_destroy :log_destroy_audit
      
      has_many(:audits, :as => :auditable) do
        def log_create!
          proxy_owner.audits.create!(:action => 'create')
        end

        def log_update!
          proxy_owner.audits.create!(:action => 'update')
        end
        
        def log_destroy!
          proxy_owner.audits.create!(:action => 'destroy')
        end
      end

      class_eval do        
        define_method(:log_create_audit) do
          audits.log_create!
        end
        
        define_method(:log_update_audit) do
          audits.log_update!
        end

        define_method(:log_destroy_audit) do
          audits.log_destroy!
        end
      end
    end
  end
end

if Object.const_defined?("ActiveRecord")
  ActiveRecord::Base.send(:include, AuditClassMethods)
end