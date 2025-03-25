module Clubs
  class SearchMemberQuery
    attr_reader :club, :query

    def initialize(club, query)
      @club = club
      @query = query
    end

    def run
      User.where.not(id: club.users.pluck(:id))
          .where("email LIKE ? OR name LIKE ?", "%#{query}%", "%#{query}%")
    end
  end
end
