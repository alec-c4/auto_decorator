# frozen_string_literal: true

require_relative "auto_decorator/version"
require_relative "auto_decorator/configuration"
require_relative "auto_decorator/loader"
require_relative "auto_decorator/railtie"

module AutoDecorator
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end
