# Comprise

Comprise brings basic List Comprehension functionality to Ruby.

> &ldquo;A list comprehension is a syntactic construct available in some programming languages for creating a list based on existing lists. It follows the form of the mathematical set-builder notation (set comprehension) as distinct from the use of map and filter functions.&rdquo; - Wikipedia

## Installation

Add this line to your application's Gemfile:

    gem 'comprise'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install comprise

## Usage

Building a comprehension goes something like:

```ruby
comp = Comprise::ListComprehension.new(y: -> { (1..5).map { |i| i * 2 } }, x: 1..2)
# => #<Comprise::ListComprehension:70101319648040>

comp.to_a
# => [[2, 1], [2, 2], [4, 1], [4, 2], [6, 1], [6, 2], [8, 1], [8, 2], [10, 1], [10, 2]]

comp.map { x * y }.to_a # to_a to trigger lazy enumeration in Ruby 2.0
# => [2, 4, 4, 8, 6, 12, 8, 16, 10, 20]
```

Comprise also adds the Kernel method `listcomp`, so all that could be done more simply with the
one-liner:

```ruby
listcomp(y: -> { (1..5).map { |i| i * 2 } }, x: 1..2) { x * y }.to_a
=> [2, 4, 4, 8, 6, 12, 8, 16, 10, 20]
```

Comprehensions can also be self referential; provided that your using a lambda or a Proc & your
referencing lists that have already been evaluated.

```ruby
listcomp(x: 1..3, y: -> { 1..x }, z: -> { [x + y] }).to_a
# => [[1, 1, 2], [2, 1, 3], [2, 2, 4], [3, 1, 4], [3, 2, 5], [3, 3, 6]]
```

*Important note: In Ruby 2.0.x Comprise makes use of Lazy enumerators.*

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
