require 'csv'

class CsvKeywordsParserService < ApplicationService
  attr_reader :file, :keywords

  def initialize(file)
    @file = file
    @keywords = []
    super
  end

  def execute
    validate
    return [] unless status

    parse
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
    @errors[:base] = e.message
    []
  end
end
