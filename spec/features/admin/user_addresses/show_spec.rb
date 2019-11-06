require 'rails_helper'

RSpec.describe 'As an admin user' do
  describe 'when I visit a specific users address show page' do
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

      @site_admin = User.create(
        name: 'Site Admin',
        email: 'site_admin@user.com',
        password: 'secure',
        role: 3)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@site_admin)

      visit "/admin/users/#{@user.id}/addresses/#{@home.id}"
    end

    scenario 'I see a the address info' do
      expect(page).to have_content("Home")
      expect(page).to have_content("123 Main")
      expect(page).to have_content("Denver, CO 80233")
    end

    scenario 'I do not see links to edit or delete the address' do
      expect(page).to_not have_link ('Edit')
      expect(page).to_not have_link ('Delete')
    end
  end
end
