class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  #追記
  has_many :favorited_users, through: :favorites, source: :book
  has_many :book_comments, dependent: :destroy

  has_many :entries
  has_many :messages
  has_many :rooms, through: :entries
  has_many :view_counts, dependent: :destroy


  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower



  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, {length: {maximum: 50}}



  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end



  def follow(user_id)
    #relationships.create(followed_id: user_id)
    unless self == user_id
      self.relationships.find_or_create_by(followed_id: user_id.to_i, follower_id: self.id)
    end
  end

  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  def self.looks(searches, words)
    if searches == "perfect_match"
      @user = User.where("name LIKE?", "#{words}")
    elsif searches == "forward_match"
      @user = User.where("name LIKE?", "#{words}%")
    elsif searches == "backward_match"
      @user = User.where("name LIKE?", "%#{words}")
    elsif searches == "partial_match"
      @user = User.where("name LIKE?", "%#{words}%")
    else
      @user = User.all
    end
  end


end
