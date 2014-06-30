class CoreMonkeypatch < Processor

  CORE = %w(Integer Fixnum String Object) # and so on...

  def initialize
    @monkey_patches = Hash.new {|h, k| h[k] = Array.new }
  end

  def result
    @monkey_patches
  end

  def process_class(exp)
    if CORE.include?(exp.value)
      @monkey_patches[exp.value] << {class: exp.value, src: exp.src}
    end
  end

end