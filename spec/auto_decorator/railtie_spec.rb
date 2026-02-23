# frozen_string_literal: true

require "rails"

RSpec.describe AutoDecorator::Railtie do
  it "is a subclass of Rails::Railtie" do
    expect(described_class.ancestors).to include(Rails::Railtie)
  end

  it "hooks into to_prepare" do
    initializer_names = described_class.initializers.map(&:name)
    expect(initializer_names).to include("auto_decorator.load")
  end
end
