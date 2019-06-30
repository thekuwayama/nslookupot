# frozen_string_literal: true

require 'resolv'
require 'socket'
require 'openssl'

q = Resolv::DNS::Message.new
q.rd = 1
q.add_question('www.cloudflare.com', Resolv::DNS::Resource::IN::A)

s = TCPSocket.new('1.1.1.1', 853)
ctx = OpenSSL::SSL::SSLContext.new('TLSv1_2')
sock = OpenSSL::SSL::SSLSocket.new(s, ctx)
sock.connect
sock.post_connection_check('cloudflare-dns.com')
# https://tools.ietf.org/html/rfc1035#section-4.2.2
#
# The message is prefixed with a two byte length field which gives the message
# length, excluding the two byte length field.
message = [q.encode.length].pack('N1')[2..] + q.encode
sock.write(message)
l = sock.read(2).unpack('C*').reverse.map.with_index { |x, i| x << 8 * i }.sum
pp Resolv::DNS::Message.decode(sock.read(l))
sock.close
s.close
