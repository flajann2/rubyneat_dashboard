require 'json'
require 'json/stream'
require_relative 'main'

module StreamHelpers
  module_function

  # Payload wrapper, giving the klass will be used for possible routing at the
  # client level.
  def wrap_for_sending(payload:, klass: :general, type: :message)
    pkt = JSON({payload: payload, klass: klass, type: type})
    "event:#{type}\ndata: #{pkt}\n\n"
  end
end
