class Tradeline < ApplicationRecord

    has_many :deposits

    def transaction(deposit_amount)
        trade_value = self.amount 
        if (trade_value - deposit_amount) <= 0
            return false
        else 
            trade_value -= deposit_amount
            self.amount = trade_value
            self.save
        end
    end
end
