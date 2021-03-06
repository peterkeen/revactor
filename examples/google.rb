#!/usr/bin/env ruby

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'revactor'
require 'cgi'

term = ARGV[0] || 'foobar'
sock = Revactor::TCP.connect("www.google.com", 80)

sock.write [
  "GET /search?q=#{CGI.escape(term)} HTTP/1.0",
  "Host: www.google.com",
  "\r\n"
].join("\r\n")

loop do
  begin
    STDOUT.write sock.read
    STDOUT.flush
  rescue EOFError
    break
  end
end
