class ArtistController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  require 'rubygems'

  def index
    @artists = Artist.all
  end

  def show

    @artist = Artist.find(params[:id])

    render = @artist.name
    # @render = Artist.new(params.require(:artist, :name))

    wikiurl = "https://en.wikipedia.org/wiki/#{render.to_s}"
    data = Nokogiri::HTML(open(wikiurl))

    @wikiscrape = data.css('#content')

    mtvurl = "http://www.mtv.com/artists/#{render.to_s}/"
    data = Nokogiri::HTML(open(mtvurl))


    @mtvscrape = data.css(".tourdate-item")
    @mtvnews = data.css("#profile_latest_news")
    @mtvnewslink = data.at_css(".list-news a[href]")

    rollingstone = "http://www.rollingstone.com/music/artists/#{render.to_s}"
    data = Nokogiri::HTML(open(rollingstone))

    @images = data.css(".main")

  def render_artist
  end

  def new
    @artist = Artist.new
  end

  def create
    @artist = Artist.new(params.require(:artist).permit(:name))

    if @artist.save
      redirect_to artist_index_path
    end
  end


  end
end
