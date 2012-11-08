class ForComp
  def initialize(*args)
    if args.first.is_a? Hash
      @context = Struct.new(*args.first.keys)
    end

    vars = args.first.is_a?(Hash) ? args.first.values : args
    enum = init_enum(vars.shift)

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
    if defined? @context
      @enumerator.map { |values| @context.new(*values).instance_eval(&Proc.new) }
    else
      @enumerator.map { |values| yield(*values) }
    end
  end

  private
  def init_enum(var)
    var = var.respond_to?(:call) ? var.call : var
    var = var.lazy if var.respond_to? :lazy

    var.map { |x| [x] }
  end
end

module Kernel
  def forcomp(*args)
    comprehension = ForComp.new(*args)

    if block_given?
      comprehension.map(&Proc.new)
    else
      comprehension
    end
  end
end
