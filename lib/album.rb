#Wrapper around rovi album data structure

require 'unicode'


class Album
  
  attr_reader :artist
  attr_reader :title
  
  def initialize(rovi_data)
    @rovi_data = rovi_data
    @title = @rovi_data["title"] || ""
    if @rovi_data["primaryArtists"] == nil
      @artist = ""
    else  
      @artist = @rovi_data["primaryArtists"][0]["name"]
    end
  end
    
  def matches(artist, title)
    equals(@artist, artist) && equals(@title, title)
  end

  def equals(a, b)
    simplify(a) == simplify(b)
  end

  def simplify(a)
    a = a.gsub(/\(.*\)$/, "").gsub(/\[.*\]$/, "")
    Unicode::decompose(a).downcase().gsub(/&/, "and").gsub(/[^a-z0-9]/, "")
  end

  def select(list, item)
    (list != nil) ? list.map { |el| el[item] || "" } : []
  end

  def genres()
    select(@rovi_data["genres"], "name")
  end
  
  def styles()
    select(@rovi_data["styles"], "name")
  end
  
  def themes()
    select(@rovi_data["themes"], "name")
  end
  
  def to_s()
    "#{artist} - #{title}"
  end

end


UNKNOWN_ALBUM = Album.new({})
