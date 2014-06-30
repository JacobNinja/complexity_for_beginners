class SendCounter < Processor

  # Store calls to :send

  def initialize
    @sends = []
  end

  def result
    @sends
  end

  def process_call(exp)
    @sends << exp if exp.value == 'send'
  end

end