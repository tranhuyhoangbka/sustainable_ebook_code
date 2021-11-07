if !Rails.env.development?
  puts "[db/seed.rb] seed data is for development only, not #{Rails.env}"
  exit 0
end

require "factory_bot"

Widget.destroy_all
Manufacturer.destroy_all
Address.destroy_all
WidgetStatus.destroy_all

puts "[db/seed.rb] creating development data"

FactoryBot.create(:widget_status, name: "Fresh")
10.times{FactoryBot.create(:manufacturer)}

cyberdyne = FactoryBot.create(:manufacturer, name: "Cyberdyne Systems")
FactoryBot.create(:widget, name: "Stembolt", manufacturer: cyberdyne)

puts "[db/seed.rb] Done"
