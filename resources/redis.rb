include Chef::Resource::ApplicationBase

attribute :role, :kind_of => [String, NilClass], :default => nil
attribute :port, :kind_of => Integer, :default => 6379
