# coding: utf-8

require 'thor'
require 'pathname'
lib = Pathname.new(__FILE__).dirname.join().expand_path
$:.unshift lib.to_s
require 'myUtil'
require 'json'


module ArxivReferences
  class CLI < Thor
    include ArxivUtil
    class_option 'work_dir', type: :string, aliases: 'Working dir', desc: 'Set working dir(default: /tmp)', default: '/tmp'
    class_option 'dir', type: :boolean, aliases: 'Working in dir', desc: 'work to make dir or not(default: true)', default: true
    class_option 'pdf', type: :boolean, aliases: 'Parse PDF', desc: 'fetch pdf information(defaut: true)', default: true


    desc 'url', 'Extract references from arxiv URL'
    def url(urlName)
      puts ArxivUtil.fetchFromUrl(urlName, options[:work_dir], options[:use_dir], options[:no_pdf]).to_json
    end

    desc 'id', 'Extract references from Arxiv id'
    def arxivid(idName)
      puts ArxivUtil.fetchFromArxivId(idName, options[:work_dir], options[:use_dir], options[:no_pdf]).to_json
    end

    desc 'pdfurl', 'Extract references from pdf URL'
    def pdfurl(pdfUrlName)
      puts ArxivUtil.fetchFromPdfUrl(pdfUrlName, options[:work_dir], options[:use_dir]).to_json
    end
  end
end
