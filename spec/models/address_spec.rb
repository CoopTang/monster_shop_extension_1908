require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
    it { should validate_numericality_of(:zip) }
  end

  describe 'relationships' do
    it { should belong_to :user }
    it { should have_many :orders }
  end

  describe 'instance methods' do
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
        name: 'Work',
        address: '456 Secondary',
        city: 'Boulder',
        state: 'CO',
        zip: 80_303
      )
    end

    it '#has_shipped_orders?' do
      order_1 = @user.orders.create(name: 'Michael', address_id: @home.id, status: 2)
      order_2 = @user.orders.create(name: 'Michael', address_id: @work.id, status: 0)
      
      expect(@home.has_shipped_orders?).to eq(true)
      expect(@work.has_shipped_orders?).to eq(false)
    end
  end
end