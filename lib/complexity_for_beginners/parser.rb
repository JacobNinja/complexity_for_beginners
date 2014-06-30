require 'codeminer'

module ComplexityForBeginners

  class Parser

    class MethodMatcher

      def self.match?(node)
        [:defn, :defs].include?(node.type) if node.respond_to?(:type)
      end

    end

    def self.methods(rb, file=nil)
      root = CodeMiner.parse(rb)
      deep_find((root || []).each, MethodMatcher)
    rescue
      puts "ERROR\n", file, rb
      raise
    end

    private

    def self.deep_find(nodes, matcher)
      nodes.each.flat_map do |node|
        if matcher.match?(node)
          [node] + deep_find(node.each, matcher)
        elsif node.respond_to?(:each)
          deep_find(node.each, matcher)
        else
          []
        end
      end
    end

  end

end