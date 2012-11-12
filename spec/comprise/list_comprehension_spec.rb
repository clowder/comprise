require File.expand_path('../../../lib/comprise', __FILE__)

describe Comprise::ListComprehension do
  it "works" do
    listcomp(x: -> { [1,2,3] }, y: -> { [4,5,6] }).to_a.should == [
      [1,4], [1,5], [1,6],
      [2,4], [2,5], [2,6],
      [3,4], [3,5], [3,6]
    ]
  end

  it "maps if passed a block" do
    listcomp(x: -> { [1,2,3] }, y: -> { [4,5,6] }) {
      "#{ x },#{ y }"
    }.to_a.should == ['1,4', '1,5', '1,6',
                      '2,4', '2,5', '2,6',
                      '3,4', '3,5', '3,6']
  end

  it "allow lists to reference earlier lists, requires lambda or Proc (i.e. deferred execution)" do
    listcomp(x: ->{ 1..3 }, y: -> { 1..x }, z: -> { [x + y] }).to_a.should == [
      [1,1,2],
      [2,1,3], [2,2,4],
      [3,1,4], [3,2,5], [3,3,6]
    ]
  end

  it "exposes a little context via #inspect" do
    comp = listcomp(x: -> { [] }, y: ->{ 0..0 }, z: ->{ [] })
    comp.inspect.should == "#<Comprise::ListComprehension:#{comp.object_id} generators:[:x, :y, :z]>"
  end
end
