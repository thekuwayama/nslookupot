# frozen_string_literal: true

module Nslookupot
  PARAMETER_REGISTRY = lambda {
    registry = %w[
      mandatory
      alpn
      no-default-alpn
      port
      ipv4hint
      ech
      ipv6hint
      dohpath
    ]
    # rubocop:disable Security/Eval
    (8...65280).each do |nnnn|
      eval "registry[nnnn] = \"undefine#{nnnn}\"", binding, __FILE__, __LINE__
    end
    (65280...65535).each do |nnnn|
      eval "registry[nnnn] = \"key#{nnnn}\"", binding, __FILE__, __LINE__
    end
    # rubocop:enable Security/Eval
    registry
  }.call.freeze

  module Refinements
    refine Resolv::DNS::SvcParams do
      unless method_defined?(:ocsp_uris)
        # rubocop: disable Metrics/CyclomaticComplexity
        # rubocop: disable Metrics/PerceivedComplexity
        define_method(:to_s) do
          @params.map do |k, v|
            key = PARAMETER_REGISTRY[k]
            value = case v
                    in Resolv::DNS::SvcParam::Mandatory
                      v.keys.map { |i| PARAMETER_REGISTRY[i] }.join(',')
                    in Resolv::DNS::SvcParam::ALPN
                      v.protocol_ids.join(',')
                    # NOTE: no-default-alpn is not supported
                    # https://github.com/ruby/resolv/blob/v0.4.0/lib/resolv.rb#L1942
                    in Resolv::DNS::SvcParam::IPv4Hint
                      v.addresses.join(',')
                    in Resolv::DNS::SvcParam::Port
                      v.port.to_s
                    in Resolv::DNS::SvcParam::Generic if v.key_number == 5
                      # ech
                      Base64.strict_encode64(v.value)
                    in Resolv::DNS::SvcParam::IPv6Hint
                      v.addresses.join(',')
                    in Resolv::DNS::SvcParam::DoHPath
                      v.template.encode('utf-8')
                    else
                      v.to_s
                    end
            "#{key}=#{value}"
          end.join(' ')
        end
        # rubocop: enable Metrics/CyclomaticComplexity
        # rubocop: enable Metrics/PerceivedComplexity
      end
    end
  end
end
