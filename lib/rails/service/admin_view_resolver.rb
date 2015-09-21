require 'action_view/template/resolver'

module Rails
  module Service
    # AdminViewResolver is a custom ActionView resolver which
    # removes the prefix normally added to path when resolvin templates.
    # Without it, we can set arbitraty view path for Rails::Service Admin controller
    class AdminViewResolver < ::ActionView::FileSystemResolver
      def initialize(path)
        super(Rails.root.join(path))
      end

      def find_templates(name, _prefix, partial, details)
        super(name, '', partial, details)
      end
    end
  end
end
