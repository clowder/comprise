module Comprise
  class ListComprehension
    def initialize(lists)
      values         = lists.values
      @context_klass = Struct.new(*lists.keys)
      @enumerator    = values.inject(init_enumerator(values.shift)) do |enumerator, enum_or_proc|
        if enum_or_proc.respond_to? :call
          enumerator.flat_map { |other| new_context(other).instance_exec(&enum_or_proc).map { |x| other + [x] } }
        else
          enumerator.flat_map { |other| enum_or_proc.map { |x| other + [x] } }
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
      "#<#{self.class.name}:#{self.object_id}>"
    end

    private
    def new_context(values)
      @context_klass.new(*values)
    end

    def init_enumerator(enum_or_proc)
      enumerator = enum_or_proc.respond_to?(:call) ? enum_or_proc.call : enum_or_proc
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
