require 'flog'

module ComplexityForBeginners

  class Complexity

    def self.score(rb, file='-')
      f = Flog.new
      f.flog_ruby(rb, file)
      f.calculate_total_scores
      f.total_score
    rescue Racc::ParseError
      0
    rescue RuntimeError
      puts "RUNTIMERRORWTF #{file}"
      0
    end

  end

end