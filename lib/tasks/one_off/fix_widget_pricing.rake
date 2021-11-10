namespace :one_off do
  desc "Fixes the widgets created before the switch to 0.95 validation"
  task fix_widget_pricing: :environment do
    OneOff::WidgetPricing.new.change_to_95_cents
  end
end
