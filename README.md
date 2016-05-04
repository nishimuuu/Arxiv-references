[![Build Status](https://travis-ci.org/nishimuuu/Arxiv-references.svg?branch=master)](https://travis-ci.org/nishimuuu/Arxiv-references)
[![Gem Version](https://badge.fury.io/rb/arxiv-references.svg)](https://badge.fury.io/rb/arxiv-references)
[![LICENSES](https://img.shields.io/badge/LICENSE-GPL-blue.svg)](https://img.shields.io/badge/LICENSE-GPL-blue.svg)
[![Code Climate](https://codeclimate.com/github/nishimuuu/Arxiv-references/badges/gpa.svg)](https://codeclimate.com/github/nishimuuu/Arxiv-references)
[![Test Coverage](https://codeclimate.com/github/nishimuuu/Arxiv-references/badges/coverage.svg)](https://codeclimate.com/github/nishimuuu/Arxiv-references/coverage)
# Arxiv::References

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/arxiv/references`. To experiment with that code, run `bin/console` for an interactive prompt.

## Demo
[URL](http://153.126.133.121/arxiv-references-api/html/index.html)

[API Document](http://153.126.133.121/arxiv-references-api/html/api.html)

## Dependencies

- k2pdfopt (http://www.willus.com/k2pdfopt/)

## Installation

### Install k2pdfopt

1. Access [this url](http://www.willus.com/k2pdfopt/download/)
2. Select version by OS and 32/64 bit and put CAPTHA
3. Move to `/usr/local/bin`
4. Confirm to use `k2pdfopt` command

### Install arxiv-references

```ruby
gem 'arxiv-references'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install arxiv-references

## Usage

### fetch paper information from arxiv url
`arxiv-ref url <arxivurl>`

### fetch paper information from arxiv ID
`arxiv-ref id <arxivid>`

### fetch paper citation list from PDF URL
`arxiv-ref pdfurl <pdfurl>`

### Options
--work_dir : [default: /tmp] working directory to convert multi column pdf to one column
--dir  : [default: true] create working directory or not
--pdf   : [default: false] if you don't need citations list, add option `--no-pdf`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/arxiv-references. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

GNU GPL
