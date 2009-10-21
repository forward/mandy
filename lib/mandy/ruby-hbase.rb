$:.unshift File.dirname(__FILE__)

require "rubygems"
require "net/http"
require "erb"
require "xml/libxml"

require "ruby-hbase/xml_decoder"
require "ruby-hbase/hbase_table"
require "ruby-hbase/scanner"