desc "Change all Approved widgets to Legacy that need it"

task change_approved_widgets_to_legacy: :environment do
  LegacyWidgets.new.change_approved_widgets_to_legacy
end
