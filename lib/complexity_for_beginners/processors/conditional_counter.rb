class ConditionalCounter < Processor

  # Counts conditionals within methods

  def initialize
    @conditionals = Hash.new {|h, k| h[k] = 0 }
  end

  def result
    @conditionals
  end

  def process_def(exp)
    @conditionals[exp.value] += find_nested(exp.each, :condition, :else).count
  end

  alias process_defs process_def

end