require 'rails_helper'

RSpec.describe 'As an admin user' do
  describe 'when I visit a specific users profile page ' do
    it 'it shows the same info the user would see on their profile page' do
      user = User.create(
        name: 'Bob',
        email: 'bob@email.com',
        password: 'secure'
      )
      home = user.addresses.create(
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233
      )
      work = user.addresses.create(
        name: 'work',
        address: '456 Secondary',
        city: 'Boulder',
        state: 'CO',
        zip: 80_303
      )

      site_admin = User.create(
        name: 'Site Admin',
        email: 'site_admin@user.com',
        password: 'secure',
        role: 3)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(site_admin)

      visit "/admin/users/#{user.id}"

      within '#user-info' do
        expect(page).to have_content('Name: Bob')
        expect(page).to have_content('Email: bob@email.com')
        expect(page).to have_link('Edit Profile')
        expect(page).to_not have_link('Edit Password')
      end

      within '#user-address-links' do
        expect(page).to have_link("Home")
        expect(page).to have_content("123 Main Denver, CO 80233")
        expect(page).to have_link("Work")
        expect(page).to have_content("456 Secondary Boulder, CO 80303")
      end
    end
  end
end
