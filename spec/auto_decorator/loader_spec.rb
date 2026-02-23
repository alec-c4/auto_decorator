# frozen_string_literal: true

require "tempfile"
require "fileutils"

RSpec.describe AutoDecorator::Loader do
  # Use a temporary directory so tests are Rails-independent
  let(:tmp_dir) { Dir.mktmpdir("auto_decorator_") }

  after { FileUtils.remove_entry(tmp_dir) }

  def write_decorator(relative_path, content)
    full = File.join(tmp_dir, relative_path)
    FileUtils.mkdir_p(File.dirname(full))
    File.write(full, content)
  end

  describe ".call" do
    context "with a simple decorator" do
      before do
        stub_const("Widget", Class.new)

        write_decorator("widget_decorator.rb", <<~RUBY)
          # frozen_string_literal: true
          module WidgetDecorator
            def decorated? = true
          end
        RUBY
      end

      it "includes the decorator into the model" do
        described_class.call(base_path: tmp_dir)
        expect(Widget.new).to be_decorated
      end

      it "does not double-include on second call" do
        described_class.call(base_path: tmp_dir)
        described_class.call(base_path: tmp_dir)
        expect(Widget.ancestors.count(WidgetDecorator)).to eq(1)
      end
    end

    context "with a namespaced decorator" do
      before do
        stub_const("Accounts", Module.new)
        stub_const("Accounts::User", Class.new)

        write_decorator("accounts/user_decorator.rb", <<~RUBY)
          # frozen_string_literal: true
          module Accounts
            module UserDecorator
              def decorated? = true
            end
          end
        RUBY
      end

      it "includes the namespaced decorator into the namespaced model" do
        described_class.call(base_path: tmp_dir)
        expect(Accounts::User.new).to be_decorated
      end
    end

    context "when the model class does not exist" do
      before do
        write_decorator("ghost_decorator.rb", <<~RUBY)
          # frozen_string_literal: true
          module GhostDecorator; end
        RUBY
      end

      it "does not raise" do
        expect { described_class.call(base_path: tmp_dir) }.not_to raise_error
      end
    end

    context "with a custom suffix" do
      before do
        stub_const("Gadget", Class.new)

        write_decorator("gadget_presenter.rb", <<~RUBY)
          # frozen_string_literal: true
          module GadgetPresenter
            def presented? = true
          end
        RUBY
      end

      it "includes the module when suffix matches" do
        described_class.call(base_path: tmp_dir, suffix: "Presenter")
        expect(Gadget.new).to be_presented
      end
    end
  end
end
