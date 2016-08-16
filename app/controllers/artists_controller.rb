class ArtistsController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  require 'rubygems'
  require 'net/http'
  require 'google/apis/customsearch_v1'
  require 'twitter'

  def index
    @artists = Artist.all
    @artist = Artist.find(params[:id])
  end

  def show
    @artists = Artist.all
    @artist = Artist.find(params[:id])

    name = @artist.name.downcase.capitalize

    client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token = ENV["TWITTER_ACCES_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCES_TOKEN_SECRET"]
    end

    @tweet = client.user_timeline("#{name}", result_type: "recent").take(4)

    gsearch = Google::Apis::CustomsearchV1::CustomsearchService.new
    gsearch.key = ENV["GOOGLE_SEARCH_KEY"]
    cx = ENV["GOOGLE_CX"]

    @results = gsearch.list_cses(
      name,
      cx: cx,
      num: 4,
      img_size: 'xlarge',
      search_type: 'image'
    )

    wikiurl = "https://en.wikipedia.org/wiki/#{name.to_s.tr(' ', '_')}"
    response = Net::HTTP.get_response(URI(wikiurl))

    case response
    when Net::HTTPSuccess
      data1 = Nokogiri::HTML(open(wikiurl))
      @wikiscrape = data1.css('#mw-content-text')
      puts @wikiscrape
    when Net::HTTPRedirection
      @wikiscrape = ""
      puts ""
    end

    mtvurl = "http://www.mtv.com/artists/#{name.downcase.parameterize.to_s}/"
    response = Net::HTTP.get_response(URI(mtvurl))

    case response
    when Net::HTTPSuccess
      data2 = Nokogiri::HTML(open(mtvurl))
      @mtvscrape = data2.css(".tourdate-item").take(8)
      @mtvnews = data2.css("#profile_latest_news")
    when Net::HTTPRedirection
      @mtvscrape = ""
      @mtvnews = ""
    end

    mtvnews = "http://www.mtv.com/artists/#{name.parameterize.to_s}/news/"
    response = Net::HTTP.get_response(URI(mtvnews))

    case response
    when Net::HTTPSuccess
      news = Nokogiri::HTML(open(mtvnews))
      @mtvnewslink = news.css(".content-body")
    when Net::HTTPRedirection
      @mtvnewslink = ""
    end

    rollingstone = "http://www.rollingstone.com/music/artists/#{name.parameterize.to_s}"
    response4 = Net::HTTP.get_response(URI(rollingstone))

    case response4
    when Net::HTTPSuccess
      data4 = Nokogiri::HTML(open(rollingstone))
      @images = data4.css(".main")
    when Net::HTTPRedirection
      @images = ""
    end

  end

  def new
    @artists = Artist.all
    @artist = Artist.new
  end

  def create
    @artists = Artist.all
    @artist = Artist.new(params.require(:artist).permit(:name))

    if @artist.save
      redirect_to artist_path(@artist)
    end
  end

  def destroy
    @artist = Artist.find(params[:id])
    @artist.destroy

    redirect_to root_path
  end

end
