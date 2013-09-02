# Request to rovi API

require 'net/http'
require 'digest/md5'
require 'yaml'


class Request

  def self.load_config()
    config = YAML.load_file("config.yml")
    @@api_key = config["api_key"]
    @@shared_secret = config["shared_secret"]
  end
  
  load_config()

  def initialize(baseurl, params)
    @baseurl = baseurl
    @params = auth_params() << params
  end
  
  def auth_params()
    timestamp = Time.now.to_i.to_s
    sig = Digest::MD5.hexdigest(@@api_key + @@shared_secret + timestamp).to_s
    return ["apikey=#{@@api_key}", "sig=#{sig}"]
  end

  def get_json()
    url = "#{@baseurl}?#{@params.join('&')}"
    response = Net::HTTP.get_response(URI.parse(url))
    return JSON.parse(response.body)
  end

end
