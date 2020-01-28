# frozen_string_literal: true

require 'optparse'

module Nslookupot
  class CLI
    # rubocop: disable Metrics/MethodLength
    def parse_options(argv = ARGV)
      op = OptionParser.new

      # default value
      opts = {
        server: '1.1.1.1',
        port: 853,
        hostname: 'cloudflare-dns.com'
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
        warn "error: #{e.message}"
        exit 1
      end

      begin
        type = s2typeclass(type)
      rescue NameError
        warn "error: unknown query type #{type}"
        exit 1
      end

      if args.size != 1
        warn op.to_s
        warn 'error: number of arguments is not 1'
        exit 1
      end

      [opts, args[0], type]
    end
    # rubocop: enable Metrics/MethodLength

    def s2typeclass(s)
      rr = Resolv::DNS::Resource::IN.const_get(s.upcase)
      raise NameError unless rr < Resolv::DNS::Resource

      rr
    end

    def run
      opts, name, type = parse_options

      resolver = Nslookupot::Resolver.new(**opts)
      puts 'Address:'.ljust(16) + opts[:server] + '#' + opts[:port].to_s
      puts '--'
      resolver.resolve_resources(name, type).each do |rr|
        puts 'Name:'.ljust(16) + name
        rr.instance_variables.each do |var|
          k = (var[1..].capitalize + ':').ljust(16)
          v = rr.instance_variable_get(var).to_s
          puts k + v
        end
        puts ''
      end
    end
  end
end
