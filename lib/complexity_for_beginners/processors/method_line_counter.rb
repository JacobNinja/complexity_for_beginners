class MethodLineCounter < Processor

  def initialize
    @line_count = {}
  end

  def result
    @line_count
  end

  def process_def(exp)
    @line_count[exp.value] = exp.src.lines.count
  end

  alias process_defs process_def

end