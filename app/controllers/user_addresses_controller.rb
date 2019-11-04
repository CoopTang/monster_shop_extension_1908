class UserAddressesController < ApplicationController
  def index
    @addresses = current_user.addresses
  end
end