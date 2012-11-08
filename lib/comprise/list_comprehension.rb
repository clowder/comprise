module Comprise
  class ListComprehension
    def initialize(lists)
      vars = lists.values
      enum = init_enum(vars.shift)

      @context    = Struct.new(*lists.keys)
      @enumerator = vars.inject(enum) do |enum, var|
        if var.respond_to? :call
          enum.flat_map { |other| var.call.map { |x| other + [x] } }
        else
          enum.flat_map { |other| var.map { |x| other + [x] } }
        end
      end
    end

    def to_a
      @enumerator.to_a
    end

    def map
      @enumerator.map { |values| @context.new(*values).instance_eval(&Proc.new) }
    end

    def inspect
      "#<#{self.class.name}:#{self.object_id}>"
    end

    private
    def init_enum(var)
      var = var.respond_to?(:call) ? var.call : var
      var = var.lazy if var.respond_to? :lazy
      var.map { |x| [x] }
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
