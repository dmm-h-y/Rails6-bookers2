class Book < ApplicationRecord

  belongs_to :user
  has_many :favorites, dependent: :destroy
  #追記
  has_many :favorited_users, through: :favorites, source: :user
  has_many :book_comments, dependent: :destroy
  has_many :view_counts, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true, length:{maximum:200}

  def favorited_by?(user)
    #favorites.exists?(user_id: user.id)
    favorites.where(user_id: user.id).exists?
  end

  def self.looks(searches, words)
    if searches == "perfect_match"
      @book = Book.where("title LIKE?", "#{words}")
    elsif searches == "forward_match"
      @book = Book.where("title LIKE?", "#{words}%")
    elsif searches == "backward_match"
      @book = Book.where("title LIKE?", "%#{words}")
    elsif searches == "partial_match"
      @book = Book.where("title LIKE?", "%#{words}%")
    else
      @book = Book.all
    end
  end



end
