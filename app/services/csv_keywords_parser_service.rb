require 'csv'

class CsvKeywordsParserService
  def initialize(file)
    @file = file
    @keywords = []
    @errors = {}
  end

  attr_reader :file, :errors, :keywords

  def execute
    validate
    return [] unless status

    parse
  end

  def status
    errors.blank?
  end

  private

  def validate
    return errors[:base] = 'File is required' unless file
    return errors[:base] = 'File type should be valid CSV' unless file.content_type == 'text/csv'
    return if CSV.read(file.tempfile).count.between?(1, 100)

    errors[:base] = 'Total keywords must between 1 and 100'
  end

  def parse
    CSV.read(file.tempfile).flatten.uniq.compact.reject(&:empty?).uniq
  rescue StandardError => e
    @errors[:base] = "Error: #{e}"
    []
  end
end
