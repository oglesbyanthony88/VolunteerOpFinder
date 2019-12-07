
class VolunteerMatch::Opportunity
  attr_accessor :name, :url # add DAF here as attributes

  @@all = []

  def initialize(name, url)
    @name = name
    @url = url
    self.save
  end

  def self.all
    @@all
  end

  def save
    @@all << self
  end


end
