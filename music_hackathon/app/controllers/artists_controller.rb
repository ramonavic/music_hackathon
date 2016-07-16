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

    @wikiscrape = data.css('#mw-content-text')

    mtvurl = "http://www.mtv.com/artists/#{render.parameterize.to_s}/"
    data = Nokogiri::HTML(open(mtvurl))


    @mtvscrape = data.css(".tourdate-item")
    @mtvnews = data.css("#profile_latest_news")
    @mtvnewslink = data.at_css(".list-news a[href]")

    rollingstone = "http://www.rollingstone.com/music/artists/#{render.parameterize.to_s}"
    data = Nokogiri::HTML(open(rollingstone))

    @images = data.css(".main")

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

  end



  end
end