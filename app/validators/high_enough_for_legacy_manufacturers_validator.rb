class HighEnoughForLegacyManufacturersValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    if value < 100_00 && record.manufacturer.created_at.year < 2010
      record.errors.add(attribute, "must be < $100 for legacy manufacturers")
    end
  end
end
