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
    option 'work_dir', type: :string, aliases: '-work', desc: 'Set working dir(default: /tmp)'
    def url(urlName)
      puts ArxivUtil.fetchFromUrl(urlName, work_dir)
    end

    desc 'id', 'Extract references from Arxiv id'
    option 'work_dir', type: :string, aliases: '-work', desc: 'Set working dir(default: /tmp)'
    def arxivid(idName)
      work_dir = options['work_dir'].nil? ? '/tmp' : options['work_dir']
      puts ArxivUtil.fetchFromArxivId(idName, work_dir)
    end

    desc 'pdfurl', 'Extract references from pdf URL'
    option 'work_dir', type: :string, aliases: '-work', desc: 'Set working dir(default: /tmp)'
    def pdfurl(pdfUrlName)
      work_dir = options['work_dir'].nil? ? '/tmp' : options['work_dir']
      puts ArxivUtil.fetchFromPdfUrl(pdfUrlName, work_dir)
    end
  end
end
