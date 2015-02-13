module Euterpe
  class Mapping
    def initialize(config)
      @config = config
    end

    def map(name, attributes)
      result = {}
      each_field(name) do |field|
        if attributes.has_key?(field['from'])
          result[field['to']] = attributes[field['from']]
        end
      end
      result
    end

    def unmap(name, attributes)
      result = {}
      each_field(name) do |field|
        if attributes.has_key?(field['to'])
          result[field['from']] = attributes[field['to']]
        end
      end
      result
    end

    private

    def each_field(name, &block)
      @config[name].each(&block)
    end
  end
end
