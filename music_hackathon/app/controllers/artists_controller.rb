class ArtistsController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  require 'rubygems'
  require 'net/http'


  def index
    @artists = Artist.all
  end

  def show
    
    @artist = Artist.find(params[:id])

    render = @artist.name.downcase
    # @render = Artist.new(params.require(:artist, :name))

    wikiurl = "https://en.wikipedia.org/wiki/#{render.to_s.tr(' ', '_')}"

    response = Net::HTTP.get_response(URI(wikiurl))

    puts response.to_s

    case response
    when Net::HTTPSuccess
      @data = Nokogiri::HTML(open(wikiurl))
      @wikiscrape = @data.css('#mw-content-text')
    when Net::HTTPRedirection
      @wikiscrape = ""
    end


    mtvurl = "http://www.mtv.com/artists/#{render.parameterize.to_s}/"

    response = Net::HTTP.get_response(URI(mtvurl))

    case response
    when Net::HTTPSuccess
      @data = Nokogiri::HTML(open(mtvurl))
      @mtvscrape = @data.css(".tourdate-item")
      @mtvnews = @data.css("#profile_latest_news")
      @mtvnewslink = @data.at_css(".list-news a[href]")
    when Net::HTTPRedirection
      @mtvscrape = ""
      @mtvnews = ""
      @mtvnewslink = ""
    end



    rollingstone = "http://www.rollingstone.com/music/artists/#{render.parameterize.to_s}"
    response = Net::HTTP.get_response(URI(rollingstone))

    case response
    when Net::HTTPSuccess
      @data = Nokogiri::HTML(open(rollingstone))
      @images = @data.css(".main")
    when Net::HTTPRedirection
      @images = ""
    end


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

  end



end
