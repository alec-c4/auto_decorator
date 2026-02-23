# frozen_string_literal: true

RSpec.describe AutoDecorator::Configuration do
  subject(:config) { described_class.new }

  describe "defaults" do
    it "sets decorators_path to app/decorators" do
      expect(config.decorators_path).to eq("app/decorators")
    end

    it "sets decorator_suffix to Decorator" do
      expect(config.decorator_suffix).to eq("Decorator")
    end
  end

  describe "assignment" do
    it "allows overriding decorators_path" do
      config.decorators_path = "app/presenters"
      expect(config.decorators_path).to eq("app/presenters")
    end

    it "allows overriding decorator_suffix" do
      config.decorator_suffix = "Presenter"
      expect(config.decorator_suffix).to eq("Presenter")
    end
  end
end
