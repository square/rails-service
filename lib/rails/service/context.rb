require 'ostruct'

module Rails
  module Service
    # Context is an object which holds common configuration and informations
    # about your service/applicaion that your service uses.
    #
    # It is very helpful when developing libraries that will be shared between
    # your services.
    class Context < OpenStruct
    end
  end
end
