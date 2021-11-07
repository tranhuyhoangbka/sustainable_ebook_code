class AdminMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.new_widget_from_new_manufacturer.subject
  #
  def new_widget_from_new_manufacturer(widget)
    @widget = widget

    mail to: "admin@example.com"
  end
end
