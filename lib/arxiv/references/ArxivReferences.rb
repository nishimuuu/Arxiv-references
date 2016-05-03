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
    option 'use_dir', type: :boolean, aliases: '-use_dir', desc: 'work to make dir or not(default: true)'
    def url(urlName)
      work_dir = options['work_dir'].nil? ? '/tmp' : options['work_dir']
      use_dir = options['use_dir'].nil? ? true : options['use_dir']
      puts ArxivUtil.fetchFromUrl(urlName, work_dir, use_dir)
    end

    desc 'id', 'Extract references from Arxiv id'
    option 'work_dir', type: :string, aliases: '-work', desc: 'Set working dir(default: /tmp)'
    option 'use_dir', type: :boolean, aliases: '-use_dir', desc: 'work to make dir or not(default: true)'
    def arxivid(idName)
      work_dir = options['work_dir'].nil? ? '/tmp' : options['work_dir']
      use_dir = options['use_dir'].nil? ? true : options['use_dir']
      puts ArxivUtil.fetchFromArxivId(idName, work_dir, use_dir)
    end

    desc 'pdfurl', 'Extract references from pdf URL'
    option 'work_dir', type: :string, aliases: '-work', desc: 'Set working dir(default: /tmp)'
    option 'use_dir', type: :boolean, aliases: '-use_dir', desc: 'work to make dir or not(default: true)'
    def pdfurl(pdfUrlName)
      work_dir = options['work_dir'].nil? ? '/tmp' : options['work_dir']
      use_dir = options['use_dir'].nil? ? true : options['use_dir']
      puts ArxivUtil.fetchFromPdfUrl(pdfUrlName, work_dir, use_dir)
    end
  end
end
