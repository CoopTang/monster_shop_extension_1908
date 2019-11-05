class UserAddressesController < ApplicationController
  def index
    @addresses = current_user.addresses
  end

  def show
    @address = Address.find(params[:address_id])
  end

  def new
  end

  def edit
  end
end