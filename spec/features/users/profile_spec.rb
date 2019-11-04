# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'As a registered user' do
  describe 'when I visit my profile page' do
    xit 'can see all profile data on the page except the password' do
      user = User.create(
        name: 'Bob',
        email: 'bob@email.com',
        password: 'secure'
      )
      user.addresses.create(
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233
      )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit profile_path

      expect(current_path).to eq(profile_path)

      within '#user-info' do
        expect(page).to have_content('Name: Bob')
        expect(page).to have_content('Address: 123 Main')
        expect(page).to have_content('City: Denver')
        expect(page).to have_content('State: CO')
        expect(page).to have_content('Zip: 80233')
        expect(page).to have_content('Email: bob@email.com')
      end
    end

    xit 'has a link to edit the user profile data' do
      user = User.create(
        name: 'Bob',
        email: 'bob@email.com',
        password: 'secure'
      )
      user.addresses.create(
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233
      )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit profile_path

      within '#user-info' do
        click_link 'Edit Profile'
      end

      expect(current_path).to eq('/profile/edit')
    end

    xit 'has a link to user order page' do
      user = User.create(
        name: 'Bob',
        email: 'bob@email.com',
        password: 'secure'
      )
      user.addresses.create(
        address: '123 Main',
        city: 'Denver',
        state: 'CO',
        zip: 80_233
      )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit profile_path

      within '#user-orders' do
        click_link 'My Orders'
      end

      expect(current_path).to eq('/profile/orders')
    end
  end
end
