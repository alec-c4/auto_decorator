# frozen_string_literal: true

require "rails"

module AutoDecorator
  class Railtie < Rails::Railtie
    initializer "auto_decorator.load" do
      config.to_prepare do
        AutoDecorator::Loader.call(
          base_path: Rails.root.join(AutoDecorator.configuration.decorators_path).to_s,
          suffix: AutoDecorator.configuration.decorator_suffix
        )
      end
    end
  end
end
