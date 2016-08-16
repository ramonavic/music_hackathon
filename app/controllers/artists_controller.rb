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

    # Twitter API Connection for latest Tweets

    client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token = ENV["TWITTER_ACCES_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCES_TOKEN_SECRET"]
    end

    @tweet = client.user_timeline("#{name}", result_type: "recent").take(4)

    # Google API connection for artist images

      # gsearch = Google::Apis::CustomsearchV1::CustomsearchService.new
      # gsearch.key = ENV["GOOGLE_SEARCH_KEY"]
      # cx = ENV["GOOGLE_CX"]
      #
      # @results = gsearch.list_cses(
      #   name,
      #   cx: cx,
      #   num: 4,
      #   img_size: 'xlarge',
      #   search_type: 'image'
      # )

    # Wikipedia Biography scraper

    wikiurl = "https://en.wikipedia.org/wiki/#{name.to_s.tr(' ', '_')}"
    response = Net::HTTP.get_response(URI(wikiurl))

    case response
    when Net::HTTPSuccess
      data = Nokogiri::HTML(open(wikiurl))
      @wikiscrape = data.css('#mw-content-text')
      puts @wikiscrape
    when Net::HTTPRedirection
      @wikiscrape = ""
      puts ""
    end


    # MTV News and tourdates scraper

    mtvurl = "http://www.mtv.com/artists/#{name.downcase.parameterize.to_s}/"
    response = Net::HTTP.get_response(URI(mtvurl))

    case response
    when Net::HTTPSuccess
      data = Nokogiri::HTML(open(mtvurl))
      @mtvscrape = data.css(".tourdate-item").take(8)
      @mtvnews = data.css("#profile_latest_news")
    when Net::HTTPRedirection
      @mtvscrape = ""
      @mtvnews = ""
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
