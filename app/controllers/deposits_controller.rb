class DepositsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    def create 
        tradeline = Tradeline.find(deposit_create[:tradeline_id])
        trade_value = tradeline.amount 
        if (trade_value - deposit_create[:amount]) <= 0
            render json: "Not enough balance in tradeline", status: 404
        else 
            deposit = Deposit.create(deposit_create)
            trade_value -= deposit.amount
            tradeline.amount = trade_value
            tradeline.save
            render json: deposit, status: :created
        end
    end

    def index
        tradeline = Tradeline.find(params[:id])
        render json: tradeline.deposits
    end
    
    def show
        render json: Deposit.find(params[:id])
    end
    

    private

    def not_found
        render json: 'not_found', status: :not_found
    end

    def deposit_create
        params.require(:deposit).permit(:deposit_date, :amount, :tradeline_id)
    end
end
