=begin rdoc
= Pipeline -- a queue to handle passing of messages between threads in a thread safe manner

This is based on and extends the Array class, and wraps it with semaphores so that
messages -- any arbitrary objects -- can be added to and removed from the Array queue across
multiple threads.

Note that any object added to this Pipeline should probably be frozen, but if it is clear
that whomever removes the object from the Pipe now owns that object, that requirement can
be relaxed.
=end

require 'aquarium'
require 'thread'

module Pipeline

  class Pipe < Array
    include Aquarium::DSL

    attr_accessor :semaphore, :resource

    def initialize
      super
      @semaphore = Mutex.new
      @resource = ConditionVariable.new
    end

    alias_method :next, :shift
    alias_method :dequeue, :shift
    alias_method :enqueue, :push
    alias_method :enqueue, :push
    # enqueue
    around calls_to: [:<<,
                      :enqueue,
                      :unshift
    ] do |join_point, pipe, *args|
      result = nil
      pipe.semaphore.synchronize {
        result = join_point.proceed
        pipe.resource.signal
      }
      result  # block needs to return the result of the "proceed"!
    end

    # dequeue
    around calls_to: [:pop,
                      :next,
                      :dequeue
    ] do |join_point, pipe, *args|
      result = nil
      pipe.semaphore.synchronize {
        while pipe.empty?
          pipe.resource.wait(pipe.semaphore)
        end
        result = join_point.proceed
      }
      result  # block needs to return the result of the "proceed"!
    end
  end

end


