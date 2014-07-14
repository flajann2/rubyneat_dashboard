require 'json'
require 'json/stream'
require_relative 'main'

# FIXME: we need to make the available functions mix in better.
module StreamHelpers
  module_function

  def wrap_for_sending(payload:, type: :message)
    "event:#{type}\ndata: #{JSON(payload)}\n\n"
  end
end
