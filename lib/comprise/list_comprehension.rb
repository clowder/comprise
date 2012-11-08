module Comprise
  class ListComprehension
    def initialize(lists)
      generators           = lists.values
      @details_for_inspect = lists.keys.zip(generators.map(&:class))
      @context_klass       = Struct.new(*lists.keys)
      @enumerator          = generators.inject(init_enumerator(generators.shift)) do |enumerator, generator|
        if generator.respond_to? :call
          enumerator.flat_map { |other| new_context(other).instance_exec(&generator).map { |x| other + [x] } }
        else
          enumerator.flat_map { |other| generator.map { |x| other + [x] } }
        end
      end
    end

    def to_a
      @enumerator.to_a
    end

    def map
      @enumerator.map { |values| new_context(values).instance_exec(&Proc.new) }
    end

    def inspect
      "#<#{self.class.name}:#{self.object_id} generators:#{ @details_for_inspect }>"
    end

    private
    def new_context(values)
      @context_klass.new(*values)
    end

    def init_enumerator(generator)
      enumerator = generator.respond_to?(:call) ? generator.call : generator
      enumerator = enumerator.lazy if enumerator.respond_to? :lazy
      enumerator.map { |x| [x] }
    end
  end
end

module Kernel
  def listcomp(lists)
    comprehension = Comprise::ListComprehension.new(lists)

    if block_given?
      comprehension.map(&Proc.new)
    else
      comprehension
    end
  end
end
