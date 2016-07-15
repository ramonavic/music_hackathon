class ArtistController < ApplicationController

def index

  require 'nokogiri'
  require 'open-uri'
  require 'rubygems'

  url = "https://en.wikipedia.org/wiki/Michael_Jackson"
  data = Nokogiri::HTML(open(url))

  @scrape = data.css('#content')

end

end
