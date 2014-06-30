class Complexity < Processor

  ASSIGNMENTS = %w(assign massign)
  BRANCHES = %w(case if elsif else call while until and or rescue when)
  OTHER = %w(alias yield)
  MAGIC = %w(include extend methods instance_methods alias_method method_added remove_method)

  def initialize
    @assignment = 0
    @branches = 0
    @other = 0
  end

  def result
    Math.sqrt(@assignment ** 2 + @branches ** 2 + @other ** 2)
  end

  ASSIGNMENTS.each do |event|
    define_method :"process_#{event}" do |*|
      @assignment += 1
    end
  end

  BRANCHES.each do |event|
    define_method :"process_#{event}" do |*|
      @branches += 1
    end
  end

  OTHER.each do |event|
    define_method :"process_#{event}" do |*|
      @other += 1
    end
  end

  def process_command(exp)
    if MAGIC.include?(exp.value)
      @other += 1
    end
  end

end