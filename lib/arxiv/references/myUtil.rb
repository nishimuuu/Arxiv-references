require 'open-uri'
require 'digest/sha2'
require 'time'
require 'fileutils'
require 'pty'
require 'expect'
require 'pdf-reader'
require 'nokogiri'
require 'json'
module ArxivUtil
  BASE_URL = "https://arxiv.org"
  REFERENCE_START_REGEXP = /References|REFERENCES|Reference|REFERENCE/
  REFERENCE_REGEXP = /(\[[0-9]?[0-9]\]|\[.+?\])/
  def self.makeId
    return Digest::SHA256.hexdigest Time.now.strftime("%F %H:%M:%S")
  end

  def self.makeDir(id)
    Dir.mkdir("/tmp/#{id}") 
  end

  def self.removeDir(id)
    FileUtils.rm_rf("/tmp/#{id}")
  end

  def self.makeFile(id)
    return "/tmp/#{id}/output.pdf"
  end

  def self. getK2Pdf(id)
    return "/tmp/#{id}/output_k2opt.pdf"
  end


  def self.fetchFromUrl(urlName)
    puts "fetch => #{urlName}"
    charset = nil
    html = open(urlName) do |f|
      charset = f.charset
      f.read
    end

    page = Nokogiri::HTML.parse(html, nil, charset)
    result = {}
    result[:title] = page.xpath('//*[@id="abs"]/div[2]/h1').text
    result[:authors] = page.xpath('//*[@id="abs"]/div[2]/div[2]/a').text
    result[:abstruct] = page.xpath('//*[@id="abs"]/div[2]/blockquote').text
    result[:pdfurl] = "#{BASE_URL}#{page.xpath('//*[@id="abs"]/div[1]/div[1]/ul/li[1]/a').attr('href').value}"
    result[:references] = fetchFromPdfUrl(result[:pdfurl]) 
    puts result.to_json
  end

  def self.fetchFromArxivId(id)
    target_url = "#{BASE_URL}/abs/#{id}" 
    fetchFromUrl(target_url)
  end

  def self.fetchFromPdfUrl(pdfUrl)
    job_id = makeId
    makeDir(job_id)
    file_name = makeFile(job_id)

    open(file_name, 'wb') do |o|
      open(pdfUrl) do |data|
        o.write(data.read)
      end
    end
    cmd = "k2pdfopt -dev kpw #{file_name}"
    PTY.spawn(cmd) do |i,o|
      o.sync = true
      i.expect(/\S.*Enter option above \(h=help, q=quit\):/,10){|line|
        o.puts "\n"
        o.flush
      }
      while( i.eof? == false )
        res = i.gets
        print res
        break unless res.index('written').nil?
      end
    end
    executed_pdf = getK2Pdf(job_id)
    reader = PDF::Reader.new(executed_pdf)
    page_no = reader.
      pages.
      reject{|i|
        i.text.index(REFERENCE_START_REGEXP).nil?
      }.
      map(&:number).
      sort.
      shift
    puts "Detect References page=> #{page_no} "
    ref_page = reader.
      pages.
      select{|i|
        i.number >= page_no
      }.
      map{|i|
        i.text.gsub(/\n+/,"\n").gsub(/ +/,' ')
      }.
      join(' ').
      gsub(REFERENCE_REGEXP,"\n\\1").
      gsub('- ','').
      split("\n")

    references = ref_page[(ref_page.index(REFERENCE_START_REGEXP)+1)..ref_page.length].
      select{|i|
      i.length > 5
    }
    removeDir(job_id)
    return references
  end
end