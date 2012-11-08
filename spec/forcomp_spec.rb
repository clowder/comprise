require File.expand_path('../../forcomp.rb', __FILE__)

describe ForComp do
  it "works" do
    forcomp(-> { [1,2,3] }, -> { [4,5,6] }).to_a.should == [
      [1,4], [1,5], [1,6],
      [2,4], [2,5], [2,6],
      [3,4], [3,5], [3,6]
    ]
  end

  it "yields to a block if passed" do
    forcomp(-> { [1,2,3] }, -> { [4,5,6] }) do |x,y|
      [x,y]
    end.to_a.should == [[1, 4], [1, 5], [1, 6],
                        [2, 4], [2, 5], [2, 6],
                        [3, 4], [3, 5], [3, 6]]
  end

  it "work with named arguments" do
    forcomp(x: -> { [1,2,3] }, y: -> { [4,5,6] }) do
      [x,y]
    end.to_a.should == [[1, 4], [1, 5], [1, 6],
                        [2, 4], [2, 5], [2, 6],
                        [3, 4], [3, 5], [3, 6]]
  end

  it "is enumerable" do
    forcomp(y: -> { [1,2,3] }, x: -> { [4,5,6] }) { x*y }.select { |i| i%6==0 }.to_a.should == [6,12,12,18]
  end

  it "works with plain enumerables" do
    forcomp(x: 1..2, y: [3,4]).to_a.should == [[1,3], [1,4],
                                               [2,3], [2,4]]
  end

  it "doesn't explode on more complex examples" do
    expect {
      forcomp(y: -> { (1..10).select { |i| i % 2 } },
              x: -> { (1..10).select { |i| i % 2 >= 0 } },
              z: 1..10) do
        y+x+z
      end.to_a
    }.not_to raise_error
  end
end
