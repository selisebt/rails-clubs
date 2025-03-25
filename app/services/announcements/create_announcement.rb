module Announcements
  class CreateAnnouncement
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def create
      Announcement.new(params).save
    end
  end
end
