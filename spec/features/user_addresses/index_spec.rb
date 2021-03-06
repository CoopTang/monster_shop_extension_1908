require 'rails_helper'

RSpec.describe 'As a registered user,' do
  describe 'when I visit My Addresses' do
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
      @work = @user.addresses.create(
        name: 'work',
        address: '456 Secondary',
        city: 'Boulder',
        state: 'CO',
        zip: 80_303
      )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit profile_addresses_path
    end

    scenario 'I see a list of all my addresses and their info' do
      within "#address-#{@home.id}" do
        expect(page).to have_link("Home")
        expect(page).to have_content("123 Main")
        expect(page).to have_content("Denver, CO 80233")
      end
      within "#address-#{@work.id}" do
        expect(page).to have_link("Work")
        expect(page).to have_content("456 Secondary")
        expect(page).to have_content("Boulder, CO 80303")
      end
    end

    scenario 'I can click on a link of an address to bring me to the address show page' do
      within "#address-#{@home.id}" do
        click_link 'Home'
      end

      expect(current_path).to eq("/profile/addresses/#{@home.id}")
    end

    scenario 'I can click on a link to add a new address' do
      click_link 'New Address'

      expect(current_path).to eq('/profile/addresses/new')
    end
  end
end