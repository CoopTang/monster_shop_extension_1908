# frozen_string_literal: true

class UserOrdersController < ApplicationController
  def index; end

  def show
    @order = Order.where(id: params[:id], user_id: current_user.id).first
    render_404 unless @order
  end

  def edit
    @order = Order.find(params[:id])
  end

  def update
    order = Order.where(id: params[:id], user_id: current_user.id).first
    order.update(order_params)
    flash[:notice] = 'Shipping address has been updated!'
    redirect_to "/orders/#{params[:id]}"
  end

  def cancel
    order = Order.where(id: params[:id], user_id: current_user.id).first
    order.update(status: 'Cancelled')
    order.item_orders.each do |item_order|
      item_order.return_inventory if item_order.status == 'Fulfilled'
      item_order.update_attributes(status: 'Unfulfilled')
    end
    flash[:notice] = 'Order has been cancelled!'
    redirect_to profile_path
  end

  private 
  
  def order_params
    params.permit(:name, :address_id)
  end
end
