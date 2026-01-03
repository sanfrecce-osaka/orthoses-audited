# frozen_string_literal: true

require_relative '../spec_helper'

RSpec.describe Orthoses::Audited do
  LOADER = lambda {
    class User < ActiveRecord::Base
      audited
    end
  }

  context 'without audit_class' do
    subject do
      Orthoses::Audited.new(
        Orthoses::Store.new(LOADER)
      ).call
    end

    it 'extends ActiveRecord::Base with Audited::Auditor::ClassMethods' do
      store = subject

      expect(store['ActiveRecord::Base'].to_rbs).to eq <<~RBS
        class ::ActiveRecord::Base
          extend Audited::Auditor::ClassMethods
        end
      RBS
    end

    it 'extends User with Audited::Auditor::AuditedClassMethods, and includes Audited::Auditor::AuditedInstanceMethods with Audited::Audit in User' do
      store = subject

      expect(store['User'].to_rbs).to match <<~RBS
        class User < ::ActiveRecord::Base
          extend Audited::Auditor::AuditedClassMethods
          include Audited::Auditor::AuditedInstanceMethods[User, Audited::Audit, Audited::Audit::ActiveRecord_Relation]
          attr_accessor audit_version: Integer?
          attr_accessor audit_comment: String?
        end
      RBS
    end

    it 'includes Audited::Auditor::ClassMethods in User::ActiveRecord_Relation' do
      store = subject

      expect(store['User::ActiveRecord_Relation'].to_rbs).to eq <<~RBS
        class User::ActiveRecord_Relation < ::ActiveRecord::Relation
          include Audited::Auditor::AuditedClassMethods
        end
      RBS
    end

    it 'includes Audited::Auditor::AuditedClassMethods in User::ActiveRecord_Associations_CollectionProxy' do
      store = subject

      expect(store['User::ActiveRecord_Associations_CollectionProxy'].to_rbs).to eq <<~RBS
        class User::ActiveRecord_Associations_CollectionProxy < ::ActiveRecord::Associations::CollectionProxy
          include Audited::Auditor::AuditedClassMethods
        end
      RBS
    end
  end

  context 'without audit_class' do
    subject do
      Orthoses::Audited.new(
        Orthoses::Store.new(LOADER),
        audit_class: 'CustomAudit'
      ).call
    end

    it 'extends ActiveRecord::Base with Audited::Auditor::ClassMethods' do
      store = subject

      expect(store['ActiveRecord::Base'].to_rbs).to eq <<~RBS
        class ::ActiveRecord::Base
          extend Audited::Auditor::ClassMethods
        end
      RBS
    end

    it 'extends User with Audited::Auditor::AuditedClassMethods, and includes Audited::Auditor::AuditedInstanceMethods with specified audit_class in User' do
      store = subject

      expect(store['User'].to_rbs).to match <<~RBS
        class User < ::ActiveRecord::Base
          extend Audited::Auditor::AuditedClassMethods
          include Audited::Auditor::AuditedInstanceMethods[User, CustomAudit, CustomAudit::ActiveRecord_Relation]
          attr_accessor audit_version: Integer?
          attr_accessor audit_comment: String?
        end
      RBS
    end

    it 'includes Audited::Auditor::ClassMethods in User::ActiveRecord_Relation' do
      store = subject

      expect(store['User::ActiveRecord_Relation'].to_rbs).to eq <<~RBS
        class User::ActiveRecord_Relation < ::ActiveRecord::Relation
          include Audited::Auditor::AuditedClassMethods
        end
      RBS
    end

    it 'includes Audited::Auditor::AuditedClassMethods in User::ActiveRecord_Associations_CollectionProxy' do
      store = subject

      expect(store['User::ActiveRecord_Associations_CollectionProxy'].to_rbs).to eq <<~RBS
        class User::ActiveRecord_Associations_CollectionProxy < ::ActiveRecord::Associations::CollectionProxy
          include Audited::Auditor::AuditedClassMethods
        end
      RBS
    end
  end
end
