require 'digest/sha2'
require 'time'
require 'fileutils'
require 'pty'
require 'expect'
require 'pdf-reader'

class P3
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
