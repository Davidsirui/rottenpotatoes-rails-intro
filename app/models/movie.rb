class Movie < ActiveRecord::Base
  def self.all_ratings
      pluck(:rating).uniq
  end

  def self.with_ratings(ratinglst)
      where("LOWER(rating) IN (?)", ratinglst.map(&:downcase))
  end
end
