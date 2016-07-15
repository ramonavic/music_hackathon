require 'rubygems'
require 'nokogiri'
require 'open-uri'

page = Nokogiri::HTML(open("http://en.wikipedia.org/"))
puts page.class   # => Nokogiri::HTML::Document

class ArtistScraper

  attr_reader :url, :data

  def initialize(url)
    @url = url
  end

  def get_class_items(class)
    data.css(class)
  end

  def data
    @data ||= Nokogiri::HTML(open(url))
  end

end
