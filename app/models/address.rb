class Address < ApplicationRecord
  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip

  validates_length_of :zip, is: 5
  validates_numericality_of :zip

  belongs_to :user
end