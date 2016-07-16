require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['kg3pJabnU2yMueHyhOYbSPjen']
  config.consumer_secret = ENV['6KqvwuQ5EUBBmhvtdslyoaaNJ3m5bRpDB2caUX8cwHSxmELzwl']
  config.access_token = ENV['57038833-FcB0uAbMK7f4ozy6TGI6XxrSP9EsMYfhTOWwIofUO']
  config.access_token_secret = ENV['2gHIH1NE3KO3cijCXZDww9bF6PtCDjHUGjkvdwMTpHBZH']
end
