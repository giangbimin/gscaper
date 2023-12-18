class ApplicationService
  attr_reader :errors

  def initialize(*_attrs)
    @errors = {}
  end

  def status
    errors.blank?
  end
end
