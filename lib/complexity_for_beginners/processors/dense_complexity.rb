class DenseComplexity < Processor

  # Measure complexity of methods with flog
  # Divide result by number of lines in method

  def initialize
    @complexity = {}
  end

  def result
    @complexity
  end

  def process_def(exp)
    complexity_score = ComplexityForBeginners::Complexity.score(exp.src)
    @complexity[exp.value] = complexity_score / exp.src.lines.count
  end

  alias process_defs process_def

end