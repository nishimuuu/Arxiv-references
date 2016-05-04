
require 'pathname'
lib = Pathname.new(__FILE__).dirname.join().expand_path.to_s
$:.unshift lib

require "references/version"
require 'references/ArxivReferences'
module Arxiv
  module References
    # Your code goes here...
  end
end
