module Rails
  module Service
    module AdminHelper
      def autoformat_action_name(action)
        action.split('_').map(&:capitalize).join(' ')
      end

      def render_sidebar
        li = []
        Rails::Service::AdminController.action_methods.sort.each do |method|
          text = autoformat_action_name(method)
          li << content_tag(:li, link_to(text, admin_path(action: method)).html_safe)
        end
        content_tag(:ul, li.join.html_safe, class: 'nav nav-stacked')
      end

      def render_rails_iframe(opts = {})
        attrs = {
          name: opts.fetch(:name),
          id: opts.fetch(:name),
          src: opts.fetch(:src),
          frameborder: '0',
          scrolling: 'no',
          onload: 'javascript:resizeIframe(this);',
        }

        content_tag(:iframe, nil, attrs)
      end

      def render_json(object)
        content_tag(:pre, content_tag(:code, JSON.pretty_generate(object), class: 'json'))
      end

      def render_title(_opts = {})
        content_for?(:title) ? yield(:title) : autoformat_action_name(controller.action_name)
      end

      def render_meta_title
        [Rails::Service.context.app, render_title].join(' / ')
      end

      def title(text)
        content_for(:title, text)
      end
    end
  end
end
