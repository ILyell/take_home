require 'rails_helper'

RSpec.describe Tradeline, type: :model do
    describe 'relations' do
        it { should have_many(:deposits)}
    end

    describe '#transaction' do
        let(:tradeline) { Tradeline.create(name: "Credit Card", amount: 1000) }
        
        it 'subtracts the deposit amount from the trade value' do
            deposit_amount = 500
            tradeline.transaction(deposit_amount)
            expect(tradeline.amount).to eq(500)
        end
    
        it 'returns false if deposit amount exceeds trade value' do
            deposit_amount = 1500
            result = tradeline.transaction(deposit_amount)
            expect(result).to eq(false)
        end
    
        it 'does not save the tradeline if deposit amount exceeds trade value' do
            deposit_amount = 1500
            tradeline.transaction(deposit_amount)
            tradeline.reload
            expect(tradeline.amount).to eq(1000)
        end
    end
end