class ErrorSerializer
  def initialize(obj)
    @obj = obj
  end

  def call
    { errors: [@obj] }
  end
end
