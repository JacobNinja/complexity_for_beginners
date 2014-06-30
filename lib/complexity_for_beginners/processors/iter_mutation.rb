class IterMutation < Processor

  METHODS_WITH_SIDE_EFFECTS = %w(<< push concat)

  def initialize
    @mutations = {}
  end

  def result
    @mutations
  end

  def process_def(exp)
    assignments = find_nested(exp.each, :assign)
    calls_to_each = find_nested(exp.each, :call) {|call| call.value == 'each' }
    calls_with_side_effects = calls_to_each.flat_map do |call|
      find_nested(call.each, :call, :binary) do |node|
        METHODS_WITH_SIDE_EFFECTS.include?(node.value)
      end
    end
    calls_with_side_effects.select(&:receiver).each do |call|
      if assignments.map(&:value).include?(call.receiver.value)
        @mutations[call.value] = call.src
      end
    end
  end

end