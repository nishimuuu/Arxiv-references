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
  REFERENCE_START_REGEXP = Regexp.new('References|REFERENCES|Reference|REFERENCE')
  REFERENCE_REGEXP = Regexp.new('(\[[0-9]?[0-9]\]|\[.+?\])')
  def self.makeId
    return Digest::SHA256.hexdigest Time.now.strftime("%F %H:%M:%S")
  end

  def self.makeDir(id, work_dir)
    Dir.mkdir("#{work_dir}/#{id}") 
  end

  def self.removeDir(id, work_dir)
    FileUtils.rm_rf("#{work_dir}/#{id}")
  end

  def self.makeFile(id, work_dir, use_dir)
    if use_dir
      return "#{work_dir}/#{id}/output.pdf"
    else
      return "#{work_dir}/#{id}-output.pdf"
    end
  end

  def self. getK2Pdf(id, work_dir, use_dir)
    if use_dir
      return "#{work_dir}/#{id}/output_k2opt.pdf"
    else
      return "#{work_dir}/#{id}-output_k2opt.pdf"
    end
  end

  def self.removeFile(id, work_dir)
    File.delete("#{work_dir}/#{id}-output.pdf")
    File.delete("#{work_dir}/#{id}-output_k2opt.pdf")
  end


  def self.fetchFromUrl(urlName, work_dir, use_dir, use_pdf)
    puts "fetch => #{urlName}"
    charset = nil
    html = open(urlName) do |f|
      charset = f.charset
      f.read
    end

    page = Nokogiri::HTML.parse(html, nil, charset)
    result = {}
    result[:title] = page.xpath('//*[@id="abs"]/div[2]/h1').children.select{|i| i.name=='text'}.shift.text.gsub(/\n/,'')
    result[:authors] = page.xpath('//*[@id="abs"]/div[2]/div[2]/a').map(&:text)
    result[:abstruct] = page.xpath('//*[@id="abs"]/div[2]/blockquote').children.select{|i| i.name = 'text'}.reverse.shift.text
    result[:pdfurl] = "#{BASE_URL}#{page.xpath('//*[@id="abs"]/div[1]/div[1]/ul/li[1]/a').attr('href').value}"
    result[:references] = fetchFromPdfUrl(result[:pdfurl], work_dir, use_dir) if use_pdf
    return result
  end

  def self.fetchFromArxivId(id, work_dir, use_dir, use_pdf)
    target_url = "#{BASE_URL}/abs/#{id}" 
    fetchFromUrl(target_url, work_dir, use_dir, use_pdf)
  end

  def self.fetchPdfFile(pdfUrl,file_name) 
    open(file_name, 'wb') do |o|
      open(pdfUrl) do |data|
        o.write(data.read)
      end
    end
  end

  def self.convertSingleColPdf(job_id, work_dir,file_name, use_dir)
    cmd = "k2pdfopt -dev kpw #{file_name}"
    PTY.spawn(cmd) do |i,o|
      o.sync = true
      i.expect(/\S.*Enter option above \(h=help, q=quit\):/,10){
        o.puts "\n"
        o.flush
      }
      while( i.eof? == false )
        res = i.gets
        print res
        break unless res.index('written').nil?
      end
    end
    return getK2Pdf(job_id, work_dir, use_dir)
  end


  def self.fetchReference(file_name)
    reader = PDF::Reader.new(file_name)
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

        return ref_page[(ref_page.index{|i| i =~ REFERENCE_START_REGEXP}+1)..ref_page.length].
          select{|i|
          i.length > 5
        }
  end

  def self.fetchFromPdfUrl(pdfUrl, work_dir, use_dir)
    job_id = makeId
    makeDir(job_id, work_dir) if use_dir
    file_name = makeFile(job_id, work_dir, use_dir)

    fetchPdfFile(pdfUrl, file_name)
    executed_pdf = convertSingleColPdf(job_id, work_dir, file_name, use_dir)
    references = fetchReference(executed_pdf)
    if use_dir
      removeDir(job_id, work_dir) 
    else
      removeFile(job_id, work_dir)
    end
    return references
  end
end
