require 'rails_helper'

RSpec.describe TradelinesController, type: :controller do
  describe '#index' do
    it 'responds with a 200' do
      get :index

      expect(response).to have_http_status(:ok)
    end
  end

  describe '#show' do
    let(:tradeline) { FactoryBot.create :tradeline }

    it 'responds with a 200' do
      get :show, params: { id: tradeline.id }
      response_amount = JSON.parse(response.body)["amount"].to_f
      expect(response_amount).to eq(3223.54)
      expect(response).to have_http_status(:ok)
    end

    context 'if the loan is not found' do
      it 'responds with a 404' do
        get :show, params: { id: 1000 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
