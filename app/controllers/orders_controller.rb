# frozen_string_literal: true

class OrdersController < ApplicationController
  def new; end

  def show
    @order = Order.find(params[:id])
  end

  def create
    order = current_user.orders.create(order_params)
    if order.save
      cart.items.each do |item, quantity|
        order.item_orders.create(
          item: item,
          quantity: quantity,
          price: item.price,
          merchant_id: item.merchant_id
        )
      end
      session.delete(:cart)
      redirect_to "/orders/#{order.id}"
    else
      flash[:notice] = 'Please complete address form to create an order.'
      render :new
    end
  end

  private

  def order_params
    address = Address.find_by(id: params[:address_id])
    if address
      {
        name: params[:name],
        address: address.address,
        city: address.city,
        state: address.state,
        zip: address.zip
      }
    else
      {
        name: nil,
        address: nil,
        city: nil,
        state: nil,
        zip: nil
      }
    end
  end
end
