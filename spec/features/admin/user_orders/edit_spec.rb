require 'rails_helper'

RSpec.describe 'As a site admin' do
  describe 'when I visit a user order edit page' do
    before :each do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @tire = @meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      @paper = @mike.items.create(name: 'Lined Paper', description: 'Great for writing on!', price: 20, image: 'https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png', inventory: 3)
      @pencil = @mike.items.create(name: 'Yellow Pencil', description: 'You can write on paper with it!', price: 2, image: 'https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg', inventory: 100)

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
        name: 'Work',
        address: '456 Secondary',
        city: 'Boulder',
        state: 'CO',
        zip: 80_303
      )

      @site_admin = User.create(name: 'Site Admin', email: 'site_admin@user.com', password: 'secure', role: 3)
      
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@site_admin)

      @order = @user.orders.create!(name: 'Meg', address_id: @home.id)

      @item_order_1 = @order.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @item_order_2 = @order.item_orders.create!(item: @paper, price: @paper.price, quantity: 3, status: 1)

      visit "/admin/users/#{@user.id}/orders/#{@order.id}/edit"
    end

    it 'I see a form with prepopulated name' do
      expect(find_field(:name).value).to eq(@order.name)
    end

    it 'I see a list of all my available addresses' do
      expect(page).to have_content("Home 123 Main Denver, CO 80233")
      expect(page).to have_content("Work 456 Secondary Boulder, CO 80303")
    end

    it 'I can update the shipping info' do
      fill_in :name, with: "Michael"

      within "#address-#{@work.id}" do
        choose "address_id"
      end

      click_button 'Update Shipping Address'

      expect(current_path).to eq("/admin/users/#{@user.id}/orders/#{@order.id}")

      within '#order-info' do
        expect(page).to have_content("Michael")
        expect(page).to have_content(@work.address)
        expect(page).to have_content(@work.city)
        expect(page).to have_content(@work.state)
        expect(page).to have_content(@work.zip)
      end
    end
  end
end
