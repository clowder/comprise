module Comprise
  class ListComprehension
    def initialize(lists)
      generators           = lists.values
      @context_klass       = Struct.new(*lists.keys)
      @enumerator          = generators.inject(init_enumerator(generators.shift)) { |enumerator, (generator,*guards)|
        enumerator.flat_map { |other|
          new_context(other).instance_exec(&generator).reject { |x|
            guards.any? { |guard| !new_context(other + [x]).instance_exec(&guard) }
          }.map { |x| other + [x] }
        }
      }
    end

    def to_a
      @enumerator.to_a
    end

    def map
      @enumerator.map { |values| new_context(values).instance_exec(&Proc.new) }
    end

    def inspect
      "#<#{self.class.name}:#{self.object_id} generators:#{ @context_klass.members }>"
    end

    private
    def new_context(values)
      @context_klass.new(*values)
    end

    def init_enumerator(generator)
      generator, *guards = generator

      enumerator = generator.call
      enumerator = enumerator.lazy if enumerator.respond_to? :lazy
      enumerator = enumerator.reject { |x|
        guards.any? { |guard| !new_context([x]).instance_exec(&guard) }
      }

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
