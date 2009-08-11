require "rubygems"
require "mandy"

include Mandy::DSL

require File.join(File.dirname(__FILE__), *%w[count])
require File.join(File.dirname(__FILE__), *%w[histogram])
require File.join(File.dirname(__FILE__), *%w[sort])