class Processor

  private

  def find_nested(nodes, *types, &filter)
    filter ||= -> * { true }
    nodes.each.flat_map do |node|
      if node.respond_to?(:type) && types.include?(node.type) && filter.call(node)
        [node] + find_nested(node.each, *types, &filter)
      elsif node.respond_to?(:each)
        find_nested(node.each, *types, &filter)
      else
        []
      end
    end
  end

end