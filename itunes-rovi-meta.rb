$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'optparse'

require 'itunes'
require 'track'  

require 'rovi'  
require 'album'

parser = OptionParser.new do |opt|
  opt.banner = "Usage: #{$0} [OPTIONS]"
  @dryrun = false
  opt.on("-d", "--dry-run", "download data and match but don't touch iTunes tracks") do
    @dryrun = true
  end
  opt.on("-v", "--verbose", "print more output") do
    @verbose = true
  end
  opt.on("-h", "--help", "help") do 
    puts parser
    exit
  end
end
parser.parse!(ARGV)

iTunes = ITunes.new
rovi = Rovi.new(@verbose)

track_list = iTunes.get_tracks()
puts "Will process #{track_list.count} tracks"
track_list.each() do |track|
  if track.file? && track.audio? && !track.compilation? 
    album = rovi.get_album(track.artist, track.album)
    if !@dryrun && album != nil then
      if album.genres().count > 0
        track.genre = album.genres()[0]
      end
      if album.styles().count > 0
        track.comment = album.styles().join(", ")
      end
    end
  end
end

