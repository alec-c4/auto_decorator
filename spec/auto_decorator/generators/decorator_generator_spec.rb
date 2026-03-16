# frozen_string_literal: true

require "rails/generators"
require "rails/version"

# Rails 7.1+ supports Testing::Behavior
# Rails 7.0 does not have the testing module
if Rails::VERSION::MAJOR > 7 || (Rails::VERSION::MAJOR == 7 && Rails::VERSION::MINOR > 0)
  require "rails/generators/testing/behavior"
  require "generators/decorator/decorator_generator"
  require "fileutils"

  RSpec.describe DecoratorGenerator do
    include Rails::Generators::Testing::Behavior
    include FileUtils

    tests described_class
    destination File.expand_path("../../../tmp/generator_test", __dir__)

    before { prepare_destination }

    describe "simple model" do
      before { run_generator ["User"] }

      it "creates app/decorators/user_decorator.rb" do
        file_path = File.join(destination_root, "app/decorators/user_decorator.rb")
        expect(File).to exist(file_path)
        content = File.read(file_path)
        expect(content).to match(/module UserDecorator/)
      end
    end

    describe "namespaced model" do
      before { run_generator ["Organizations::Employee"] }

      it "creates app/decorators/organizations/employee_decorator.rb" do
        file_path = File.join(destination_root, "app/decorators/organizations/employee_decorator.rb")
        expect(File).to exist(file_path)
        content = File.read(file_path)
        expect(content).to match(/module Organizations/)
        expect(content).to match(/module EmployeeDecorator/)
      end
    end
  end
else
  RSpec.describe "DecoratorGenerator" do
    it "skips generator tests on Rails 7.0 (no testing support)" do
      skip "Rails generators testing not available in Rails 7.0"
    end
  end
end
