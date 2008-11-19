require 'rs_param_parser'
require 'rs_iso_json'

require 'rs_abstract_accessors'
require 'rs_range_header'
require 'rs_will_paginate'
require 'rs_sorting'

case ActionController.restful_subsystem
when 'resource_controller'
  require 'resource_controller_rails_store'
when 'make_resourceful'
  require 'make_resourceful_rails_store'
when 'scaffold'
  require 'scaffold_rails_store'
end

require 'rs_base'
