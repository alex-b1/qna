class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :omniauthable,
         omniauth_providers: [:github, :vkontakte]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def author?(item)
    id == item.user_id
  end

  def subscribed?(object)
    object.subscriptions.where(user: self).exists?
  end

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
