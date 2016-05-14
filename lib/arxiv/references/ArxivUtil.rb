
$:.unshift Pathname.new(__FILE__).dirname.join().expand_path.to_s
require 'ArxivApi'
require 'paper/pdf/parser/p3'


module ArxivUtil
  BASE_URL = "https://arxiv.org"
  def self.fetchFromUrl(urlName, work_dir, use_dir, use_pdf)
    arxiv = ArxivApi.new(urlName)
    arxiv.references = P3.fetchFromPdfUrl(arxiv.pdfurl, work_dir, use_dir) if use_pdf || use_pdf.nil? 
    return arxiv
  end

  def self.fetchFromArxivId(id, work_dir, use_dir, use_pdf)
    target_url = "#{BASE_URL}/abs/#{id}" 
    fetchFromUrl(target_url, work_dir, use_dir, use_pdf)
  end

  def self.fetchFromPdfUrl(pdfUrl, work_dir, use_dir)
    return P3.fetchFromPdfUrl(pdfUrl, work_dir, use_dir)
  end
end
