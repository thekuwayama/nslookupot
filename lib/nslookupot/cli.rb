# frozen_string_literal: true

require 'optparse'

module Nslookupot
  class CLI
    # rubocop: disable Metrics/AbcSize
    # rubocop: disable Metrics/MethodLength
    def parse_options(argv = ARGV)
      op = OptionParser.new

      # default value
      opts = {
        server: '1.1.1.1',
        port: 853,
        hostname: 'cloudflare-dns.com',
        check_sni: true
      }
      type = 'A'

      op.on(
        '-s',
        '--server VALUE',
        "the name server IP address        (default #{opts[:server]})"
      ) do |v|
        opts[:server] = v
      end

      op.on(
        '-p',
        '--port VALUE',
        "the name server port number       (default #{opts[:port]})"
      ) do |v|
        opts[:port] = v
      end

      op.on(
        '-h',
        '--hostname VALUE',
        "the name server hostname          (default #{opts[:hostname]})"
      ) do |v|
        opts[:hostname] = v
      end

      op.on(
        '-n',
        '--no-check-sni',
        "no check SNI                      (default #{!opts[:check_sni]})"
      ) do
        opts[:check_sni] = false
      end

      op.on(
        '-t',
        '--type VALUE',
        "the type of the information query (default #{type})"
      ) do |v|
        type = v
      end

      op.banner += ' name'
      begin
        args = op.parse(argv)
      rescue OptionParser::InvalidOption => e
        warn op.to_s
        warn "** #{e.message}"
        exit 1
      end

      begin
        type = s2typeclass(type)
      rescue NameError
        warn "** unknown query type: #{type.upcase}"
        exit 1
      end

      if args.size != 1
        warn op.to_s
        warn '** `name` argument is not specified'
        exit 1
      end

      [opts, args[0], type]
    end
    # rubocop: enable Metrics/AbcSize
    # rubocop: enable Metrics/MethodLength

    def s2typeclass(s)
      rr = Resolv::DNS::Resource::IN.const_get(s.upcase)
      raise NameError unless rr < Resolv::DNS::Resource

      rr
    end

    # rubocop: disable Metrics/AbcSize
    def run
      opts, name, type = parse_options

      resolver = Resolver.new(**opts)
      puts 'Server:'.ljust(16) + opts[:server]
      puts 'Address:'.ljust(16) + "#{opts[:server]}\##{opts[:port]}"
      puts

      result = nil
      begin
        result = resolver.resolve_resources(name, type)
      rescue Error::DNNotFound
        t = type.name.split('::').last
        warn "** Not Found: (domain, type) = (#{name}, #{t})"
        exit 1
      rescue Error::DoTServerUnavailable => e
        warn "** DoT Server Unavailable: #{e.message}"
        exit 1
      end

      result.each do |rr|
        puts 'Name:'.ljust(16) + name
        rr.instance_variables.each do |var|
          k = var.to_s.delete('@').split('_').map(&:capitalize).join
          k = "#{k}:".ljust(16)
          v = rr.instance_variable_get(var).to_s
          puts k + v
        end
        puts
      end
    end
    # rubocop: enable Metrics/AbcSize
  end
end
