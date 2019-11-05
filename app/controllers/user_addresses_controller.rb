class UserAddressesController < ApplicationController
  def index
    @addresses = current_user.addresses
  end

  def show
    @address = Address.find(params[:address_id])
  end

  def new
  end

  def create
    address = current_user.addresses.create(address_params)
    if address.save
      flash[:success] = 'Address has been created!'
      redirect_to '/profile/addresses'
    else
      flash[:error] = address.errors.full_messages.to_sentence
      redirect_to '/profile/addresses/new'
    end
  end

  def edit
    @address = Address.find(params[:address_id])
  end

  def update
    address = Address.find(params[:address_id])
    address.update(address_params)
    if address.save
      flash[:success] = 'Your address has been updated!'
      redirect_to "/profile/addresses/#{address.id}"
    else
      flash[:error] = address.errors.full_messages.to_sentence
      redirect_to "/profile/addresses/#{address.id}/edit"
    end
  end

  def destroy
    Address.destroy(params[:address_id])
    flash[:success] = 'Address has been deleted!'
    redirect_to '/profile/addresses'
  end

  private

  def address_params
    params.permit(:name,:address,:city,:state,:zip)
  end
end