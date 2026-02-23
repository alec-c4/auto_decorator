# frozen_string_literal: true

require "pathname"

module AutoDecorator
  class Loader
    def self.call(base_path:, suffix: "Decorator")
      base = Pathname.new(base_path)
      Dir.glob(base.join("**/*_#{suffix.downcase}.rb")).each do |file|
        load_file(file, base, suffix)
      end
    end

    def self.load_file(file, base_path, suffix)
      relative = Pathname.new(file).relative_path_from(base_path).to_s.delete_suffix(".rb")
      decorator_name = relative.split("/").map { |part| camelize(part) }.join("::")
      model_name = decorator_name.delete_suffix(suffix)

      load file
      decorator_module = Object.const_get(decorator_name)
      model_class = Object.const_get(model_name)
      return if model_class.include?(decorator_module)

      model_class.include(decorator_module)
    rescue NameError
      # Model or decorator constant not found — skip silently
    end
    private_class_method :load_file

    def self.camelize(str)
      str.split("_").map(&:capitalize).join
    end
    private_class_method :camelize
  end
end
