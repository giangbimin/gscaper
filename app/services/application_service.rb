class ApplicationService
  attr_reader :errors

  def initialize(*)
    @errors = {}
  end

  def status
    errors.blank?
  end

  class << self
    def call(...)
      new(...).call
    end
  end
end
