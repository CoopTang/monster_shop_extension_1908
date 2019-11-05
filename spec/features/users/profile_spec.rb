# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'As a registered user' do
  describe 'when I visit my profile page' do
    it 'can see all profile data on the page except the password' do
      user = User.create(
        name: 'Bob',
        email: 'bob@email.com',
        password: 'secure'
      )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit profile_path

      expect(current_path).to eq(profile_path)

      within '#user-info' do
        expect(page).to have_content('Name: Bob')
        expect(page).to have_content('Email: bob@email.com')
      end
    end

    it 'has a link to edit the user profile data' do
      user = User.create(
        name: 'Bob',
        email: 'bob@email.com',
        password: 'secure'
      )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit profile_path

      within '#user-info' do
        click_link 'Edit Profile'
      end

      expect(current_path).to eq('/profile/edit')
    end

    it 'has a link to user order page' do
      user = User.create(
        name: 'Bob',
        email: 'bob@email.com',
        password: 'secure'
      )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit profile_path

      within '#user-orders' do
        click_link 'My Orders'
      end

      expect(current_path).to eq('/profile/orders')
    end

    it 'has a link to a users address page' do
      user = User.create(
        name: 'Bob',
        email: 'bob@email.com',
        password: 'secure'
      )

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit profile_path

      within '#user-addresses' do
        click_link 'My Addresses'
      end

      expect(current_path).to eq('/profile/addresses')
    end
  end
end
