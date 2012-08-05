require 'neology/property_mixin/class_methods'
require 'neology/utils/data_type_converter'

module Neology
  module PropertyMixin
  # TODO: replace node or rel

    def []= key, value
      old_value = self.properties[key.to_s]
      if (value != old_value)
        self.properties[key.to_s] = value
        $neo_server.send :"set_#{node_or_rel}_properties", self.id, self.properties
        if self.class.is_indexed?(key)
          self.class.send :"update_#{node_or_rel}_index", self.id, key.to_s, old_value, value
        end
      end
    end

    def [] key
      self.properties = $neo_server.send :"get_#{node_or_rel}_properties", self.id
      value = self.properties[key.to_s]
      options = self.class.properties_hash[key.to_sym]
      value = Neology::DataTypeConverter.convert_to_native value, options[:type] if (options && options[:type])
      value
    end

  end
end