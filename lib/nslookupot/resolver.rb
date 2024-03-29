# frozen_string_literal: true

module Nslookupot
  class Resolver
    # @param server [String]
    # @param port [Integer]
    # @param hostname [String]
    # @param check_sni [bool]
    def initialize(
      server: '1.1.1.1',
      port: 853,
      hostname: 'cloudflare-dns.com',
      check_sni: true
    )
      @server = server
      @port = port
      @hostname = hostname # for SNI
      @check_sni = check_sni
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
    # @raise [Nslookupot::Error]
    #
    # @return [Array of Resolv::DNS::Resource]
    def resolve_resources(name, typeclass)
      begin
        sock = gen_sock
        send_msg(sock, name, typeclass)
        msg = recv_msg(sock)
        sock.close
      rescue SocketError, Errno::ECONNREFUSED
        err_msg = "#{@server}\##{@port} connection refused"
        raise Error::DoTServerUnavailable.new, err_msg
      rescue OpenSSL::SSL::SSLError => e
        raise Error::DoTServerUnavailable.new, e.message
      end

      result = msg.answer.map(&:last)
      raise Error::DNNotFound if result.empty?

      result
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
      l = sock.read(2).unpack1('n')

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
      message = [q.encode.length].pack('n') + q.encode
      sock.write(message)
    end

    # @return [OpenSSL::SSL::SSLSocket]
    def gen_sock
      ts = TCPSocket.new(@server, @port)
      ctx = OpenSSL::SSL::SSLContext.new
      ctx.min_version = OpenSSL::SSL::TLS1_2_VERSION
      ctx.max_version = OpenSSL::SSL::TLS1_2_VERSION
      ctx.max_version = OpenSSL::SSL::TLS1_3_VERSION \
        if defined? OpenSSL::SSL::TLS1_3_VERSION
      ctx.alpn_protocols = ['dot']
      sock = OpenSSL::SSL::SSLSocket.new(ts, ctx)
      sock.sync_close = true
      if @check_sni
        sock.hostname = @hostname
        sock.connect
        sock.post_connection_check(@hostname)
      else
        sock.connect
      end

      sock
    end
  end
end
