class ArtistsController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  require 'rubygems'
  require 'net/http'

  def index
    @artists = Artist.all
    @artist = Artist.find(params[:id])

  end

  def show
    @artists = Artist.all
    @artist = Artist.find(params[:id])

    render = @artist.name.downcase.capitalize

    wikiurl = "https://en.wikipedia.org/wiki/#{render.to_s.tr(' ', '_')}"
    response1 = Net::HTTP.get_response(URI(wikiurl))

    puts response1.to_s

    case response1
    when Net::HTTPSuccess
      data1 = Nokogiri::HTML(open(wikiurl))
      @wikiscrape = data1.css('#mw-content-text')
      puts @wikiscrape
    when Net::HTTPRedirection
      @wikiscrape = ""
      puts ""
    end

    mtvurl = "http://www.mtv.com/artists/#{render.downcase.parameterize.to_s}/"
    response2 = Net::HTTP.get_response(URI(mtvurl))

    case response2
    when Net::HTTPSuccess
      data2 = Nokogiri::HTML(open(mtvurl))
      @mtvscrape = data2.css(".tourdate-item")
      @mtvnews = data2.css("#profile_latest_news")
    when Net::HTTPRedirection
      @mtvscrape = ""
      @mtvnews = ""
    end

    mtvnews = "http://www.mtv.com/artists/#{render.parameterize.to_s}/news/"
    response3 = Net::HTTP.get_response(URI(mtvnews))

    case response3
    when Net::HTTPSuccess
      news = Nokogiri::HTML(open(mtvnews))
      @mtvnewslink = news.css(".content-body")
    when Net::HTTPRedirection
      @mtvnewslink = ""
    end

    rollingstone = "http://www.rollingstone.com/music/artists/#{render.parameterize.to_s}"
    response4 = Net::HTTP.get_response(URI(rollingstone))

    case response4
    when Net::HTTPSuccess
      data4 = Nokogiri::HTML(open(rollingstone))
      @images = data4.css(".main")
    when Net::HTTPRedirection
      @images = ""
    end

    client = Twitter::REST::Client.new do |config|
      config.consumer_key = 'kg3pJabnU2yMueHyhOYbSPjen'
      config.consumer_secret = '6KqvwuQ5EUBBmhvtdslyoaaNJ3m5bRpDB2caUX8cwHSxmELzwl'
      config.access_token = '57038833-FcB0uAbMK7f4ozy6TGI6XxrSP9EsMYfhTOWwIofUO'
      config.access_token_secret = '2gHIH1NE3KO3cijCXZDww9bF6PtCDjHUGjkvdwMTpHBZH'
    end

    @tweet = client.user_timeline("#{render}", result_type: "recent").take(5)

  end

  def new
     @artists = Artist.all

    @artist = Artist.new
  end

  def create
     @artists = Artist.all

    @artist = Artist.new(params.require(:artist).permit(:name))

    if @artist.save
      redirect_to root_path
    end
  end

  def destroy
    @artists = Artist.all

    @artist = Artist.find(params[:id])
    @artist.destroy

    redirect_to root_path
  end

end
