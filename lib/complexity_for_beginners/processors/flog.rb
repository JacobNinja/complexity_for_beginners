NullClass = Struct.new(:exp) do
  def value
    'main'
  end

  def parent
    exp.parent
  end
end

NullMethod = Struct.new(:exp) do
  def value
    'none'
  end

  def parent
    exp.parent
  end
end

class FlogProcessor

  FlogScore = Struct.new(:score, :type)

  def initialize(file)
    @expressions = {}
    @penalties = {}
    @file = file
  end

  def parent_method(exp)
    parent = exp.parent
    parent = parent.parent until parent.nil? || [:defn, :defs].include?(parent.type)
    parent || NullMethod.new(exp)
  end

  def parent_class(exp)
    parent = exp.parent
    until parent.nil? || parent.type == :class do
      parent = parent.parent
    end
    parent || NullClass.new(exp)
  end

  def result
    penalties = @penalties.each_with_object(Hash.new(0)) do |(exp, penalty), hsh|
      @expressions.keys.each do |e|
        hsh[e] += penalty if @scopes[exp].include?(e)
      end
    end
    method_scores = @expressions.keys.group_by(&method(:parent_method)).each_with_object({}) do |(parent, children), hsh|
      scores = children.each_with_object(Hash.new(0)) do |n, hsh|
        score = @expressions[n].score
        new_score = score + (penalties[n] * score)
        case @expressions[n].type
          when :assignment
            hsh[:assignment] += new_score
          when :branch
            hsh[:branch] += new_score
          else
            hsh[:other] += new_score
        end
      end
      hsh[parent] = Math.sqrt(scores[:assignment] ** 2 + scores[:branch] ** 2 + scores[:other] ** 2)
    end
    method_scores.keys.group_by(&method(:parent_class)).each_with_object({}) do |(parent, children), hsh|
      children.each do |child|
        hsh["#{parent.value}##{child.value}"] = method_scores[child]
      end
    end
  end

  SCORES = Hash.new(1)

  BRANCHING = [ :and, :case, :else, :if, :or, :rescue, :until, :when, :while ]

  OTHER_SCORES = {
      :alias          => 2,
      :assignment     => 1,
      :block          => 1,
      :block_pass     => 1,
      :branch         => 1,
      :lit_fixnum     => 0.25,
      :sclass         => 5,
      :super          => 1,
      :to_proc_icky!  => 10,
      :to_proc_lasgn  => 15,
      :to_proc_normal => case RUBY_VERSION
                           when /^1\.8\.7/ then

                           when /^1\.9/ then
                             1.5
                           when /^2\.[01]/ then
                             1
                           else
                             5
                         end,
      :yield          => 1,
  }

  SCORES.merge!(:define_method => 5,
                :eval          => 5,
                :module_eval   => 5,
                :class_eval    => 5,
                :instance_eval => 5)

  SCORES.merge!(:alias_method               => 2,
                :extend                     => 2,
                :include                    => 2,
                :instance_method            => 2,
                :instance_methods           => 2,
                :method_added               => 2,
                :method_defined?            => 2,
                :method_removed             => 2,
                :method_undefined           => 2,
                :private_class_method       => 2,
                :private_instance_methods   => 2,
                :private_method_defined?    => 2,
                :protected_instance_methods => 2,
                :protected_method_defined?  => 2,
                :public_class_method        => 2,
                :public_instance_methods    => 2,
                :public_method_defined?     => 2,
                :remove_method              => 2,
                :send                       => 3,
                :undef_method               => 2)

  SCORES.merge!(:inject => 2)

  def self.process(*attrs)
    attrs.each do |attr|
      define_method :"process_#{attr}" do |exp|
        add_to_score(exp, FlogScore.new(OTHER_SCORES.fetch(exp.type, 0), exp.type))
      end
    end
  end

  def self.process_branch(*attrs)
    attrs.each do |attr|
      define_method :"process_#{attr}" do |exp|
        @penalties[exp] = 0.1
        add_to_score(exp, FlogScore.new(1, :branch))
      end
    end
  end

  process :yield, :alias, :super

  def process_call(exp)
    if SCORES.keys.include?(exp.value.to_sym)
      add_to_score(exp, FlogScore.new(SCORES[exp.value.to_sym], exp.value.to_sym))
    elsif BRANCHING.include?(exp.value.to_sym)
      add_to_score(exp, FlogScore.new(1, :branch))
    else
      @penalties[exp] = 0.2
      add_to_score(exp, FlogScore.new(1, :call))
    end
  end

  def process_binary(exp)
    if exp.value.to_sym == :and
      @penalties[exp] = 0.1
      add_to_score(exp, FlogScore.new(1, :branch))
    elsif SCORES.keys.include?(exp.value.to_sym)
      add_to_score(exp, FlogScore.new(SCORES[exp.value.to_sym], exp.value.to_sym))
    elsif BRANCHING.include?(exp.value.to_sym)
      add_to_score(exp, FlogScore.new(1, :branch))
    end
  end

  process_branch :case, :else, :if, :elsif, :rescue, :when, :until, :while

  alias process_command process_call

  def process_assign(exp)
    add_to_score(exp, FlogScore.new(1, :assignment))
  end

  alias process_massign process_assign

  def process_int(exp)
    add_to_score(exp, FlogScore.new(OTHER_SCORES[:lit_fixnum], :lit_fixnum))
  end

  def add_to_score(flog_exp, flog_score)
    @expressions[flog_exp] = flog_score
  end

end
