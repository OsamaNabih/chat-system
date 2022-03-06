class Chat < ApplicationRecord
  belongs_to :application
  has_many :message
end
