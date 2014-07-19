require 'spec_helper'
require 'thread'

CNT = 100000
CNTI = CNT
CNTO = CNT

describe Pipeline::Pipe do
  before(:each) do
    @pipe = Pipeline::Pipe.new

    class Foobar
      def initialize
        @stuff = [1, 2, 3]
      end

    end
    @foo = Foobar.new
  end

  it "Pipe can be created" do
    expect(@pipe).to_not be_nil
  end

  it "pushes an object into the pipe" do
    @pipe << @foo
    expect(@pipe.first).to eq @foo
  end

  it "extracts an object from the pipe" do
    @pipe << @foo
    bar = @pipe.pop
    expect(bar).to eq @foo
  end

  it "handles concurrency" do
    tout = Thread.new do
      (0..CNTO).each{ |j|
        (i, num) = @pipe.next
        expect(j).to eq i
        expect(num).to eq j * 7 + 3
      }
    end
    tin = Thread.new do
      (0..CNTI).map{|i| [i, i * 7 + 3]}.each{|pair| @pipe << pair }
    end
    tin.join
    tout.join
    expect(@pipe.empty?).to be_truthy
  end
end
