# frozen_string_literal: true

require "rails/generators"

module AutoDecorator
  module Generators
    class DecoratorGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)

      def create_decorator_file
        template "decorator.rb.tt",
          File.join("app/decorators", class_path.join("/"), "#{file_name}_decorator.rb")
      end

      private

      def decorator_name
        "#{class_name.demodulize}Decorator"
      end

      def namespaces
        class_name.deconstantize.split("::").reject(&:empty?)
      end
    end
  end
end
