class Whitespace < Processor

  # Find usages of binary operators without whitespace on either side

  def initialize
    @binary = []
  end

  def result
    @binary
  end

  def process_binary(exp)
    regex = /#{Regexp.escape(exp.left.src)}\s+#{Regexp.escape(exp.value)}\s+#{Regexp.escape(exp.right.src)}/
    unless exp.src =~ regex
      @binary << exp
    end
  end

end