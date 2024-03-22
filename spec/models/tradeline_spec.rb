require 'rails_helper'

RSpec.describe Tradeline, type: :model do
    describe 'relations' do
        it { should have_many(:deposits)}
    end
end