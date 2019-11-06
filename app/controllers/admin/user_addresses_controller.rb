class Admin::UserAddressesController < Admin::BaseController
  def show
    @address = Address.find(params[:address_id])
  end
end