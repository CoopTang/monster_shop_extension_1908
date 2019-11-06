class Admin::UserOrdersController < Admin::BaseController

  def show
    @order = Order.find(params[:order_id])
  end

  def edit
    @order = Order.find_by(id: params[:order_id], user_id: params[:user_id])
  end

  def update
    order = Order.where(id: params[:order_id], user_id: params[:user_id])
    order.update(order_params)
    flash[:notice] = 'Shipping address has been updated!'
    redirect_to "/admin/users/#{params[:user_id]}/orders/#{params[:order_id]}"
  end

  def cancel
    order = Order.where(id: params[:order_id], user_id: params[:user_id]).first
    order.update(status: 'Cancelled')
    order.item_orders.each do |item_order|
      item_order.return_inventory if item_order.status == 'Fulfilled'
      item_order.update_attributes(status: 'Unfulfilled')
    end
    flash[:notice] = 'Order has been cancelled!'
    redirect_to "/admin/users/#{params[:user_id]}"
  end

  private 
  
  def order_params
    params.permit(:name, :address_id)
  end
end
