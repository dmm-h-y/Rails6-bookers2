class Room < ApplicationRecord
  has_many :entries
  has_many :messages
  
end
