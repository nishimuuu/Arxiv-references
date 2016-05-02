# coding: utf-8

require 'thor'
require 'pathname'
lib = Pathname.new(__FILE__).dirname.join().expand_path
$:.unshift lib.to_s
require 'myUtil'


module ArxivReferences
  class CLI < Thor
    include ArxivUtil
    desc 'url', 'Extract references from arxiv URL'
    def url(urlName)
      return ArxivUtil.fetchFromUrl(urlName)
    end

    desc 'id', 'Extract references from Arxiv id'
    def arxivid(idName)
      return ArxivUtil.fetchFromArxivId(idName)
    end

    desc 'pdfurl', 'Extract references from pdf URL'
    def pdfurl(pdfUrlName)
      return ArxivUtil.fetchFromPdfUrl(pdfUrlName)
    end
  end
end
