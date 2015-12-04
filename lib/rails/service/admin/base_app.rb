require 'sinatra/base'

module Rails
  module Service
    class BaseAdminApp < Sinatra::Base
      BASE_PATH = "/_admin".freeze

      enable :logging

      configure do
        set :public_folder, "#{File.dirname(__FILE__)}/public"
        set :views, "#{File.dirname(__FILE__)}/views"
        set :erb, layout: :default_layout
      end

      helpers do
        def render_meta_title

        end

        def render_title

        end

        def render_sidebar
          "<ul class=\"nav nav-stacked\">#{@@sidebar.sort.map{ |item, href| "<li><a href=\"#{BASE_PATH}#{href}\">#{item}</a></li>" }.join}</ul>"
        end

        def csrf_meta_tags
          # TODO use rack-protect
        end

        def service_context
          Rails::Service.context
        end

        def render_pretty_json(object)
          "<pre><code class=\"json\">#{JSON.pretty_generate(object)}</code></pre>"
        end
      end

      @@sidebar = {}

      def self.sidebar(items)
        @@sidebar.merge!(items)
      end
    end
  end
end
