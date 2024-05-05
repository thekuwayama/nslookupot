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
        define_method(:to_s) do
          @params.map do |k, v|
            key = PARAMETER_REGISTRY[k]
            value = case v
                    when Resolv::DNS::SvcParam::Mandatory
                      v.keys.map { |i| PARAMETER_REGISTRY[i] }.join(',')
                    when Resolv::DNS::SvcParam::ALPN
                      v.protocol_ids.join(',')
                    # NOTE: no-default-alpn is not supported
                    # https://github.com/ruby/resolv/blob/v0.4.0/lib/resolv.rb#L1942
                    when Resolv::DNS::SvcParam::IPv4Hint
                      v.addresses.join(',')
                    when Resolv::DNS::SvcParam::Port
                      v.port.to_s
                    when Resolv::DNS::SvcParam::Generic::Key5 # ech
                      Base64.strict_encode64(v.value)
                    when Resolv::DNS::SvcParam::IPv6Hint
                      v.addresses.join(',')
                    else
                      v.to_s
                    end
            "#{key}=#{value}"
          end.join(' ')
        end
        # rubocop: enable Metrics/CyclomaticComplexity
      end
    end
  end
end
