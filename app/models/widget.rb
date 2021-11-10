class Widget < ApplicationRecord
  belongs_to :manufacturer
  belongs_to :widget_status

  validates :name, presence: true, length: {minimum: 5}
  validates :price_cents, presence: true,
    numericality: {less_than_or_equal_to: 10_000_00, greater_than: 0},
    high_enough_for_legacy_manufacturers: true

  before_validation do
    if self.name.blank?
      self.name = nil
    end
  end

  def user_facing_identifier
    id_as_string = self.id.to_s
    if id_as_string.length < 3
      return id_as_string
    end
    "%{first}.%{last_two}" % {first: id_as_string[0..-3], last_two: id_as_string[-2..-1]}
  end

  def as_json(options={})
    options[:methods] ||= [ :user_facing_identifier ]
    options[:except] ||= [ :widget_status_id ]
    options[:include] ||= [ :widget_status ]
    super(options)
  end
end
