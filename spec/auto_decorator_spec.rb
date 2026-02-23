# frozen_string_literal: true

RSpec.describe AutoDecorator do
  it "has a version number" do
    expect(AutoDecorator::VERSION).not_to be_nil
  end

  it "is loadable" do
    expect(defined?(described_class)).to be_truthy
  end
end
