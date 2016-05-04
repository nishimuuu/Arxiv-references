require 'open-uri'
require 'nokogiri'
require 'json'

class ArxivApi
  attr_reader :title, :authors, :abstruct, :pdfurl
  attr_accessor :references
  BASE_URL = 'https://arxiv.org'
  def initialize(id)
    id = "#{BASE_URL}/abs/#{id}" if id.index('http').nil?
    charset = nil
    html = open(id) do |f|
      charset = f.charset
      f.read
    end
    @page = Nokogiri::HTML.parse(html, nil, charset)
    @title = fetch_title
    @authors = fetch_authors
    @abstruct = fetch_abstruct
    @pdfurl = fetch_pdfurl
    @references = nil
  end

  def fetch_title
    @page.xpath('//*[@id="abs"]/div[2]/h1').children.select{|i| i.name=='text'}.shift.text.gsub(/\n/,'')
  end

  def fetch_authors
    @page.xpath('//*[@id="abs"]/div[2]/div[2]/a').map(&:text)
  end

  def fetch_abstruct
    @page.xpath('//*[@id="abs"]/div[2]/blockquote').children.select{|i| i.name = 'text'}.reverse.shift.text
  end

  def fetch_pdfurl
    "#{BASE_URL}#{@page.xpath('//*[@id="abs"]/div[1]/div[1]/ul/li[1]/a').attr('href').value}"
  end

  def to_json
    JSON.pretty_generate({title: @title, authors: @authors, abstruct: @abstruct, pdfurl: @pdfurl, references: @references})
  end

end


