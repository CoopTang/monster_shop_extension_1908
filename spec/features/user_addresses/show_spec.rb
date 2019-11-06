require 'rails_helper'

RSpec.describe 'As a registered user,' do
  describe 'when I visit an address show page' do
    before :each do
      @user = User.create(
        name: 'Bob',
        email: 'bob@email.com',
        password: 'secure'
      )
      @home = @user.addresses.create(
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233
      )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/profile/addresses/#{@home.id}"
    end

    scenario 'I see a the address info' do
      expect(page).to have_link("Home")
      expect(page).to have_content("123 Main")
      expect(page).to have_content("Denver, CO 80233")
    end

    scenario 'I can click on a link to edit that address' do
      click_link 'Edit'

      expect(current_path).to eq(profile_addresses_edit_path(@home))
    end

    scenario 'I can click on a link to delete the address' do
      click_link 'Delete'

      expect(current_path).to eq('/profile/addresses')

      expect(page).to have_content('Address has been deleted!')

      expect(page).to_not have_css("address-#{@home.id}")
    end

    scenario 'I cannot delete an address that has been used in an order that has been shipped already' do
      @user.orders.create(name: 'Michael', address_id: @home.id, status: 2)

      visit "/profile/addresses/#{@home.id}"
      
      expect(page).to_not have_link('Delete')
    end
  end
end