require 'rails_helper'

RSpec.describe "Deposits", type: :request do
    let(:tradeline) { FactoryBot.create :tradeline }

    it 'Creates a deposit' do
        # Setup headers for first deposit post
        headers = { "CONTENT_TYPE" => "application/json" }
        body = { "deposit" => { "deposit_date": "1/1/1", "amount": 1000, "tradeline_id": tradeline.id } }
        # Gets the tradeline object to test amount
        get tradelines_path, params: { id: tradeline.id }
        response_amount = JSON.parse(response.body)[0]["amount"].to_f
        # Test for correct base amount
        expect(response_amount).to eq(3223.54)
        expect(response).to have_http_status(:ok)

        # Creates deposit
        post deposits_path, params: body.to_json, headers: headers
        expect(response).to have_http_status(201)
        # Checks if correct response, and if tradeline amount has been updated
        get tradelines_path, params: { id: tradeline.id }
        new_response_amount = JSON.parse(response.body)[0]["amount"].to_f
        expect(response).to have_http_status(200)
        expect(new_response_amount).to eq(0.222354e4)

        # Creates second deposit to insure correct updating of tradeline object
        body_2 = { "deposit" => { "deposit_date": "1/2/1", "amount": 500, "tradeline_id": tradeline.id } }

        post deposits_path, params: body_2.to_json, headers: headers
        expect(response).to have_http_status(201)
        get tradelines_path, params: { id: tradeline.id }
        new_response_amount = JSON.parse(response.body)[0]["amount"].to_f
        expect(response).to have_http_status(200)
        expect(new_response_amount).to eq(1723.54)
    end

    it 'Dosent create deposit if deposit would bring tradeline amount below 0' do
        headers = { "CONTENT_TYPE" => "application/json" }
        body = { "deposit" => { "deposit_date": "1/1/1", "amount": 10000, "tradeline_id": tradeline.id } }

        post deposits_path, params: body.to_json, headers: headers

        expect(response).to have_http_status(404)
    end


    it 'Returns a single deposit' do
        deposit = Deposit.create(deposit_date: "1/1/1", amount: 100, tradeline_id: tradeline.id)
        get deposits_path, params: { id: deposit.id }
        response_amount = JSON.parse(response.body)[0]["amount"].to_f
        expect(response).to have_http_status(:ok)
        expect(response_amount).to eq(100)
    end

    it 'Returns all deposits for a tradeline' do
        Deposit.create(deposit_date: "1/1/1", amount: 100, tradeline_id: tradeline.id)
        Deposit.create(deposit_date: "1/2/1", amount: 400, tradeline_id: tradeline.id)
        Deposit.create(deposit_date: "1/3/1", amount: 200, tradeline_id: tradeline.id)
        get deposits_path, params: { id: tradeline.id }
        expect(response).to have_http_status(:ok)
        response_amount = JSON.parse(response.body)
        expect(response_amount.count).to eq(3)
    end
end
