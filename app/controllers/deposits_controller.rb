class DepositsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    def create 
        tradeline = Tradeline.find(deposit_create_params[:tradeline_id])
        if tradeline.transaction(deposit_create_params[:amount]) 
            Deposit.create(deposit_create_params)
            render json: 'Deposit Successful', status: 201
        else
            render json: 'Insuffceint Amount', status: 404
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

    def deposit_create_params
        params.require(:deposit).permit(:deposit_date, :amount, :tradeline_id)
    end
end
