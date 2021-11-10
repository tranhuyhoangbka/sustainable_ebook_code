# Preview all emails at http://localhost:3000/rails/mailers/finance_mailer
class FinanceMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/finance_mailer/high_priced_widget
  def high_priced_widget
    manufacturer = FactoryBot.build(:manufacturer, name: "Cyberdyne Systems")
    widget = FactoryBot.build(:widget, id: 1234, name: "Stembolt",
      price_cents: 8100_00, manufacturer: manufacturer)
    FinanceMailer.high_priced_widget(widget)
  end

end
