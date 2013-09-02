# Wrapper around the iTunes track object

class Track

  attr_reader :artist
  attr_reader :album
  
  def initialize(iTunes_track)
    @iTunes_track = iTunes_track
    albumArtist = @iTunes_track.album_artist.get
    @artist = albumArtist != "" ? albumArtist : @iTunes_track.artist.get
    @album = @iTunes_track.album.get
  end
  
  def compilation?
     @iTunes_track.compilation.get == true
  end

  def audio?
    (@iTunes_track.kind.get =~ /audio file/) != nil && @iTunes_track.genre.get != "Podcast"
  end
  
  def file?
    (@iTunes_track.class_.get.to_s() == "file_track")
  end
  
  def genre=(text)
    @iTunes_track.genre.set(text)
  end
  
  def comment=(text)
    @iTunes_track.comment.set(text)
  end
  
  def to_s()
    "#{@iTunes_track.name.get} - #{@artist}"
  end
  
end
