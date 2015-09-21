module Dummy
  module Service
    module Status
      module Actions
        def foobar
          render_status :warning, foobar: 'barfoo'
        end
      end
    end
  end
end
