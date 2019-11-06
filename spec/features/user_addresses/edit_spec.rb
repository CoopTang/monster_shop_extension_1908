require 'rails_helper'

RSpec.describe 'As a registered user,' do
  describe 'when I visit an address edit page from the show page' do
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

      visit "/profile/addresses/#{@home.id}/edit"
    end

    scenario 'I see a the address info prepopulated' do
      expect(find_field(:name).value).to eq(@home.name)
      expect(find_field(:address).value).to eq(@home.address)
      expect(find_field(:city).value).to eq(@home.city)
      expect(find_field(:state).value).to eq(@home.state)
      expect(find_field(:zip).value).to eq("80233")
    end

    scenario 'I can edit the address information' do
      fill_in :name, with: 'Work'
      fill_in :address, with: '456 Secondary'
      fill_in :city, with: 'Boulder'
      fill_in :state, with: 'Colorado'
      fill_in :zip, with: 80_303

      click_button 'Update Address'

      expect(current_path).to eq("/profile/addresses/#{@home.id}")

      expect(page).to have_content('Your address has been updated!')
    end

    scenario 'I must fill out the form properly' do
      fill_in :name, with: nil
      fill_in :address, with: nil
      fill_in :city, with: nil
      fill_in :state, with: nil
      fill_in :zip, with: nil
      
      click_button 'Update Address'

      expect(page).to have_content('Name can\'t be blank')
      expect(page).to have_content('Address can\'t be blank')
      expect(page).to have_content('City can\'t be blank')
      expect(page).to have_content('State can\'t be blank')
      expect(page).to have_content('Zip can\'t be blank')
    end
  end
end