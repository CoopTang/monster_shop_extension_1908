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

  def destroy
    Address.destroy(params[:address_id])
    flash[:success] = 'Address has been deleted!'
    redirect_to '/profile/addresses'
  end
end