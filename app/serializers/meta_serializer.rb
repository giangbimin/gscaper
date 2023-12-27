class MetaSerializer
  def initialize(obj)
    @obj = obj
  end

  def call
    { meta: @obj }
  end
end
