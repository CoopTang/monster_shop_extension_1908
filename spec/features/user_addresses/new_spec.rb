require 'rails_helper'

RSpec.describe 'As a registered user,' do
  describe 'when I visit the new address page' do
    before :each do
      @user = User.create(
        name: 'Bob',
        email: 'bob@email.com',
        password: 'secure'
      )
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit '/profile/addresses/new'
    end

    scenario 'I can fill out a form to create a new address' do
      fill_in :name, with: 'work'
      fill_in :address, with: '456 Secondary'
      fill_in :city, with: 'Boulder'
      fill_in :state, with: 'CO'
      fill_in :zip, with: 80_303

      click_on 'Create Address'

      expect(current_path).to eq('/profile/addresses')

      expect(page).to have_content('Address has been created!')

      within "#address-#{Address.last.id}" do
        expect(page).to have_link("Work")
        expect(page).to have_content("456 Secondary")
        expect(page).to have_content("Boulder, CO 80303")
      end
    end

    scenario "I cannot make a new address with blank fields" do
      fill_in :name, with: nil
      fill_in :address, with: nil
      fill_in :city, with: nil
      fill_in :state, with: nil
      fill_in :zip, with: nil

      click_on 'Create Address'

      expect(current_path).to eq('/profile/addresses/new')

      expect(page).to have_content('Name can\'t be blank')
      expect(page).to have_content('Address can\'t be blank')
      expect(page).to have_content('City can\'t be blank')
      expect(page).to have_content('State can\'t be blank')
      expect(page).to have_content('Zip can\'t be blank')
    end
  end
end
