require File.expand_path('../../../lib/comprise', __FILE__)

describe Comprise::ListComprehension do
  it "works" do
    listcomp(x: -> { [1,2,3] }, y: -> { [4,5,6] }).to_a.should == [
      [1,4], [1,5], [1,6],
      [2,4], [2,5], [2,6],
      [3,4], [3,5], [3,6]
    ]
  end

  it "yields to a block if passed" do
    listcomp(x: -> { [1,2,3] }, y: -> { [4,5,6] }) do
      [x,y]
    end.to_a.should == [[1, 4], [1, 5], [1, 6],
                        [2, 4], [2, 5], [2, 6],
                        [3, 4], [3, 5], [3, 6]]
  end

  it "returns an enumerable" do
    listcomp(y: -> { 1..3 }, x: -> { 4..6 }) { x*y }.select { |i| i%6==0 }.to_a.should == [6,12,12,18]
  end

  it "works with enumerable objects" do
    listcomp(x: 1..2, y: [3,4]).to_a.should == [[1,3], [1,4],
                                               [2,3], [2,4]]
  end

  it "doesn't explode on more complex examples" do
    expect {
      listcomp(y: -> { (1..5).map { |i| i * 2 } },
               x: -> { (1..10).select { |i| i % 2 > 0 } },
               z: 1..10) do
        x+y+z
      end.to_a
    }.not_to raise_error
  end

  it "allow lists to reference earlier lists, requires lambda or Proc (i.e. deferred execution)" do
    listcomp(x: 1..3, y: -> { 1..x }, z: -> { [x + y] }).to_a.should == [
      [1,1,2],
      [2,1,3], [2,2,4],
      [3,1,4], [3,2,5], [3,3,6]
    ]
  end

  it "exposes a little context via #inspect" do
    comp = listcomp(x: [], y: 0..0, z: ->{ []})
    comp.inspect.should == "#<Comprise::ListComprehension:#{comp.object_id} generators:[[:x, Array], [:y, Range], [:z, Proc]]>"
  end
end
