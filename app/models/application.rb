class Application < ApplicationRecord
  has_many :chats, dependent: :destroy

  has_secure_token :length => 28

  scope :select_exclude_id, ->  { select( Application.attribute_names - ['id'] ) }
end
