# Wrapper around iTunes AppleScript object 

require 'appscript'


class ITunes

  def initialize()
    @iTunes = Appscript.app.by_name("iTunes")
  end

  def get_tracks()
    iTunes_tracks = @iTunes.selection.get
    if iTunes_tracks.count == 0
      iTunes_tracks = @iTunes.library_playlists[1].tracks.get
    end
    iTunes_tracks.map{ |t| Track.new(t) }
  end

end
