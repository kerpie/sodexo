class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  before_save :ensure_authentication_token

  belongs_to :user_type
  has_many :authorizations
  has_many :restaurants, through: :authorizations

  def ensure_authentication_token
  	if authentication_token.blank?
  		self.authentication_token = generate_authentication_token
  	end
  end

  def generate_authentication_token
  	loop do 
  		token = Devise.friendly_token
  		break token unless User.where(authentication_token: token).first
  	end
  end

end