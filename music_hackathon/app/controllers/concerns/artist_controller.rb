class ArtistController < ApplicationController

  def index

    require 'nokogiri'
    require 'open-uri'
    require 'rubygems'

    wikiurl = "https://en.wikipedia.org/wiki/Adele"
    data = Nokogiri::HTML(open(wikiurl))

    @wikiscrape = data.css('#content')

    mtvurl = "http://www.mtv.com/artists/adele/"
    data = Nokogiri::HTML(open(mtvurl))

    @mtvscrape = data.css(".tourdate-item")
    @mtvnews = data.css("div #profile_latest_news div.title.multiline")

    @img_urls = data.css('.content-body img').map{ |i| i['src'] }

  end

end
