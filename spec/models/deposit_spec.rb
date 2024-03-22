require 'rails_helper'

RSpec.describe Deposit, type: :model do
    describe 'relations' do
        it { should belong_to(:tradeline) }
    end
end