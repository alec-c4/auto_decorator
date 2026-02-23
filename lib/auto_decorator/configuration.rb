# frozen_string_literal: true

module AutoDecorator
  class Configuration
    attr_accessor :decorators_path, :decorator_suffix

    def initialize
      @decorators_path = "app/decorators"
      @decorator_suffix = "Decorator"
    end
  end
end
