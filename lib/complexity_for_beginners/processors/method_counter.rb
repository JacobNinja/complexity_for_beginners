class MethodCounter < Processor

  # Count the number of methods per class

  def initialize
    @method_count = Hash.new {|h, k| h[k] = 0 }
  end

  def result
    @method_count
  end

  def process_class(exp)
    @method_count[exp.value] += find_nested(exp.each, :defn, :defs).count
  end

end