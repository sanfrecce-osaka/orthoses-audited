# frozen_string_literal: true

require 'orthoses'
require_relative 'audited/version'

module Orthoses
  class Audited
    def initialize(loader, audit_class: 'Audited::Audit')
      @loader = loader
      @audit_class = audit_class
    end

    def call
      include = CallTracer::Lazy.new
      store = include.trace('Audited::Auditor::ClassMethods#audited') do
        @loader.call
      end

      include.captures.each do |capture|
        base_name = Utils.module_name(capture.method.receiver) or next
        sig = 'extend Audited::Auditor::ClassMethods'
        if !store['ActiveRecord::Base'].body.include?(sig)
          store['ActiveRecord::Base'] << sig
        end
        store[base_name] << 'extend Audited::Auditor::AuditedClassMethods'
        store[base_name] << "include Audited::Auditor::AuditedInstanceMethods[#{base_name}, #{@audit_class}, #{@audit_class}::ActiveRecord_Relation]"
        store[base_name] << 'attr_accessor audit_version: Integer?'
        store[base_name] << 'attr_accessor audit_comment: String?'
        store["#{base_name}::ActiveRecord_Relation"] << 'include Audited::Auditor::AuditedClassMethods'
        store["#{base_name}::ActiveRecord_Associations_CollectionProxy"] << 'include Audited::Auditor::AuditedClassMethods'
      end
      store
    end
  end
end
