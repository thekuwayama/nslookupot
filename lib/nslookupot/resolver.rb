# frozen_string_literal: true

module Nslookupot
  class Resolver
    # @param server [String]
    # @param port [Integer]
    # @param hostname [String]
    def initialize(server = '1.1.1.1', port = 853,
                   hostname = 'cloudflare-dns.com')
      @server = server
      @port = port
      @hostname = hostname # for SNI
    end

    # @param name [String]
    #
    # @return [Resolv::IPv4 | Resolv::IPv6]
    def resolve_address(name)
      resolve_resources(name, Resolv::DNS::Resource::IN::A).first.address
    end

    # @param name [String]
    #
    # @return [Array of Resolv::IPv4 | Resolv::IPv6]
    def resolve_addresses(name)
      resolve_resources(name, Resolv::DNS::Resource::IN::A).map(&:address)
    end

    # @param name [String]
    # @param typeclass [Resolv::DNS::Resource::IN constant]
    #
    # @return [Array of Resolv::DNS::Resource]
    def resolve_resources(name, typeclass)
      sock = gen_sock
      send_msg(sock, name, typeclass)
      msg = recv_msg(sock)
      sock.close

      msg.answer.map(&:last)
    end

    private

    # @param sock [OpenSSL::SSL::SSLSocket]
    #
    # @return [Resolv::DNS::Message]
    def recv_msg(sock)
      # The message is prefixed with a two byte length field which gives the
      # message length, excluding the two byte length field.
      #
      # https://tools.ietf.org/html/rfc1035#section-4.2.2
      l = sock.read(2).unpack('C2').map.with_index { |x, i|
        x << 8 * (1 - i)
      }.sum

      Resolv::DNS::Message.decode(sock.read(l))
    end

    # @param sock [OpenSSL::SSL::SSLSocket]
    # @param name [String]
    # @param typeclass [Resolv::DNS::Resource::IN constant]
    def send_msg(sock, name, typeclass)
      q = Resolv::DNS::Message.new
      q.rd = 1 # recursion desired
      q.add_question(name, typeclass)
      # The message is prefixed with a two byte length field
      message = [q.encode.length].pack('N1')[2..] + q.encode
      sock.write(message)
    end

    # @return [OpenSSL::SSL::SSLSocket]
    def gen_sock
      ts = TCPSocket.new(@server, @port)
      ctx = OpenSSL::SSL::SSLContext.new('TLSv1_2')
      sock = OpenSSL::SSL::SSLSocket.new(ts, ctx)
      sock.sync_close = true
      sock.connect
      sock.post_connection_check(@hostname)

      sock
    end
  end
end
