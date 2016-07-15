class ArtistController < ApplicationController

  def index

    require 'nokogiri'
    require 'open-uri'
    require 'rubygems'

    wiki = "https://en.wikipedia.org/wiki/Adele"
    data = Nokogiri::HTML(open(wiki))

    @wikiscrape = data.css('#content')

    mtv = "http://www.mtv.com/artists/adele/"
    data = Nokogiri::HTML(open(mtv))

    @mtvscrape = data.css(".tourdate-item")
    @mtvnews = data.css("#profile_latest_news")
    @mtvnewslink = data.at_css(".list-news a[href]")

    rollingstone = "http://www.rollingstone.com/music/artists/adele"
    data = Nokogiri::HTML(open(rollingstone))

    @images = data.css(".main")

  end
end
