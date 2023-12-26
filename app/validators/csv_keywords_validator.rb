require 'csv'

class CsvKeywordsValidator < ActiveModel::Validator
  attr_reader :user_order, :file

  def validate(user_order)
    @user_order = user_order
    @file = @user_order.file

    validate_file
  end

  private

  def validate_file
    return unless check_file_presence

    return unless check_file_type

    check_keyword_count
  end

  def check_file_presence
    return true if file.present?

    user_order.errors.add(:base, 'File is required')
    false
  end

  def check_file_type
    return true if file.content_type == 'text/csv'

    user_order.errors.add(:base, 'File type should be valid CSV')
    false
  end

  def check_keyword_count
    keywords_count = CSV.read(file.tempfile).count
    return true if keywords_count.between?(1, 100)

    user_order.errors.add(:base, 'Total keywords must be between 1 and 100')
    false
  end
end
