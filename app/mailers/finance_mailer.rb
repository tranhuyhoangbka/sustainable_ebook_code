class FinanceMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.finance_mailer.high_priced_widget.subject
  #
  def high_priced_widget(widget)
    @widget = widget

    mail to: "finance@example.com"
  end
end
