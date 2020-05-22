require "uri"
require "cgi"
require "json"
require "net/http"

def require_so uri, idx = 0
  match = URI(uri).path.match /\/a\/(\d+)/
  raise LoadError.new("not a valid StackOverflow short answer url: ${uri}") unless match

  api_uri = URI("https://api.stackexchange.com/2.2/posts/%s?order=desc&sort=activity&site=stackoverflow&filter=!T.nr)x27oD_I19ncr1" % match[1])
  begin 
    code = JSON.load(Net::HTTP.get(api_uri))["items"][0]["body"].scan /<pre><code>(.*?)<\/code><\/pre>/m
  rescue
    raise LoadError.new("not a valid StackOverflow answer: ${uri}")
  end
  
  raise LoadError.new("answer has no code snippets: ${uri}") unless code

  eval CGI.unescapeHTML(code.fetch(idx)[0])
end
