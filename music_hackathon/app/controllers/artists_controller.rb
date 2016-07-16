class ArtistsController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  require 'rubygems'

  def index
    @artists = Artist.all
  end

  def show

    @artist = Artist.find(params[:id])

    render = @artist.name.downcase
    # @render = Artist.new(params.require(:artist, :name))

    wikiurl = "https://en.wikipedia.org/wiki/#{render.to_s.tr(' ', '_')}"
    data = Nokogiri::HTML(open(wikiurl))

    @wikiscrape = data.css('#content')

    mtvurl = "http://www.mtv.com/artists/#{render.parameterize.to_s}/"
    data = Nokogiri::HTML(open(mtvurl))

    mtvnews = "http://www.mtv.com/artists/#{render.parameterize.to_s}/news/"
    news = Nokogiri::HTML(open(mtvnews))

    @mtvscrape = data.css(".tourdate-item")
    @mtvnewslink = news.css(".content-body")

    mtvimages = "http://www.mtv.com/artists/#{render.parameterize.to_s}/photos/"
    data = Nokogiri::HTML(open(mtvimages))

    @images = data.css(".content-body")

    client = Twitter::REST::Client.new do |config|
      config.consumer_key = 'kg3pJabnU2yMueHyhOYbSPjen'
      config.consumer_secret = '6KqvwuQ5EUBBmhvtdslyoaaNJ3m5bRpDB2caUX8cwHSxmELzwl'
      config.access_token = '57038833-FcB0uAbMK7f4ozy6TGI6XxrSP9EsMYfhTOWwIofUO'
      config.access_token_secret = '2gHIH1NE3KO3cijCXZDww9bF6PtCDjHUGjkvdwMTpHBZH'
    end

    @tweet = client.user_timeline("#{render}", result_type: "recent").take(3)

  def render_artist
  end

  def new
    @artist = Artist.new
  end

  def create
    @artist = Artist.new(params.require(:artist).permit(:name))

    if @artist.save
      redirect_to root_path
    end
  end

  def destroy
    @artist = Artist.find(params[:id])
    @artist.destroy

    redirect_to root_path
  end

  end
end
