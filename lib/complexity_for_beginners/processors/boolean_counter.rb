class BooleanCounter < Processor

  BOOLEAN_OPS = %w(|| &&)

  def initialize
    @binary = []
  end

  def process_binary(exp)
    @binary << exp if BOOLEAN_OPS.include?(exp.value)
  end

  def result
    blacklist = []
    @binary.reverse.each_with_object({}) do |exp, hsh|
      next if blacklist.include?(exp)

      binary_expressions = find_nested(exp.each, :binary) do |binary|
        BOOLEAN_OPS.include?(binary.value)
      end
      blacklist += binary_expressions
      hsh[exp] = binary_expressions.count.next
    end
  end

end