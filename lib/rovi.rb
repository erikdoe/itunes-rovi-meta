# Basically a repository for albums, backed by rovi. Caches in local filesystem.

require 'CGI'
require 'json'

require 'album'
require 'request'


class Rovi

  def initialize(verbose)
    @log_all = verbose
    @search_hash = {}
    ensure_cache_exists()
  end
  
  def ensure_cache_exists()
    if !Dir.exists?("cache") then
      Dir.mkdir("cache")
    end
  end

  def ensure_search_cached(album)
    filename = "cache/#{CGI::escape(album).downcase()}.json"
    return filename if File.exists?(filename)

    baseurl = "http://api.rovicorp.com/search/v2.1/music/search"
    params = [ "entitytype=album", "query=#{CGI::escape(album)}", "include=styles,themes"]
  
    doc = Request.new(baseurl, params).get_json()
    pretty = JSON.pretty_generate(doc)
    File.open(filename, "w") { |file| file.write(pretty) }
    return filename
  end
  
  def search(artist, title)
    puts "\nSearching for #{artist} - #{title}" if @log_all
    filename = ensure_search_cached(title)
    doc = JSON.parse(File.read(filename))
    results = doc["searchResponse"]["results"]
    if results == nil
      puts "\nSearching for #{artist} - #{title}" if !@log_all
      puts "** No results from rovi"
      return nil
    end
    albums = []
    results.each() do |r|
      if r["type"] != "album" then
        puts "** Skipping non-album response in #{filename}; found #{r['type']}"
        next
      end
      a = Album.new(r["album"])
      albums << a
      if a.matches(artist, title)
        puts "FOUND         #{a.to_s()}" if @log_all
        return a
      end
    end
    puts "\nSearching for #{artist} - #{title}" if !@log_all
    puts "** No matches found"
    albums.each { |a| puts "Considered    #{a.to_s()}"}
    return nil
  end
    
  def get_album(artist, title)
    title = title.sub(/\(.*\)$/, "").sub(/\[.*\]$/, "")
    key = "#{artist}**#{title}"
    entry = @search_hash[key]
    if entry == nil then
      entry = search(artist, title)
      @search_hash[key] = entry || UNKNOWN_ALBUM
    end
    return (entry == UNKNOWN_ALBUM) ? nil : entry
  end
  
end

  