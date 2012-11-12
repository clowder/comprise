require File.expand_path('../../../lib/comprise', __FILE__)
require 'ostruct'

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

  it "allows you to specify a predicate for the input set" do
    owners = ->{ [OpenStruct.new(name: 'Chris', car_name: 'Hilux'),
                  OpenStruct.new(name: 'Lucy',  car_name: 'Mini')] }
    cars   = ->{ [OpenStruct.new(name: 'Hilux', manufacture_date: 2008),
                  OpenStruct.new(name: 'Mini',  manufacture_date: 2012) ] }

    car_list = listcomp(owner: owners,
                        car:   [cars, ->{ owner.car_name == car.name }]) {
      "#{ owner.name } drives a #{ car.manufacture_date } #{ car.name }"
    }

    car_list.should == ["Chris drives a 2008 Hilux", "Lucy drives a 2012 Mini"]
  end
end
