module OneOff
  class WidgetPricing
    def change_to_95_cents
      Widget.find_each do |widget|
        puts "logic"
      end
    end
  end
end
