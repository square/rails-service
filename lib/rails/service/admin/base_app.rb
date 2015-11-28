require 'sinatra/base'

module Rails
  module Service
    class BaseAdminApp < Sinatra::Base
      helpers do
        def render_meta_title

        end

        def render_title

        end

        def render_sidebar

        end

        def csrf_meta_tags
          # TODO use rack-protect
        end

        def service_context
          Rails::Service.context
        end
      end

      set :public_folder, "#{File.dirname(__FILE__)}/public"

      get '/' do
        erb :test, layout: :layout
      end
    end
  end
end
