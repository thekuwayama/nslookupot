# frozen_string_literal: true

require 'resolv'
require 'socket'

q = Resolv::DNS::Message.new
q.rd = 1
q.add_question('www.cloudflare.com', Resolv::DNS::Resource::IN::A)

s = UDPSocket.new
s.bind('0.0.0.0', 0)
s.send(q.encode, 0, '1.1.1.1', 53)
pp Resolv::DNS::Message.decode(s.recvfrom(65535).first)
s.close
