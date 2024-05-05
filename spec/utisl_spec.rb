# frozen_string_literal: true

require_relative 'spec_helper'

# rubocop: disable Metrics/BlockLength
RSpec.describe Nslookupot::Refinements do
  using Nslookupot::Refinements

  context 'SvcParams#to_s' do
    let(:mandatory) do
      Resolv::DNS::SvcParams.new(
        [
          Resolv::DNS::SvcParam::Mandatory.new([5, 6, 8, 6544])
        ]
      )
    end

    it 'could to_s' do
      expect(mandatory.to_s).to eq 'mandatory=ech,ipv6hint,undefine8,undefine6544'
    end

    let(:alpn) do
      Resolv::DNS::SvcParams.new(
        [
          Resolv::DNS::SvcParam::ALPN.new(%w[h2 h3])
        ]
      )
    end

    it 'could to_s' do
      expect(alpn.to_s).to eq 'alpn=h2,h3'
    end

    let(:port) do
      Resolv::DNS::SvcParams.new(
        [
          Resolv::DNS::SvcParam::Port.new(80)
        ]
      )
    end

    it 'could to_s' do
      expect(port.to_s).to eq 'port=80'
    end

    let(:ipv4hint) do
      Resolv::DNS::SvcParams.new(
        [
          Resolv::DNS::SvcParam::IPv4Hint.new(%w[192.168.0.1])
        ]
      )
    end

    it 'could to_s' do
      expect(ipv4hint.to_s).to eq 'ipv4hint=192.168.0.1'
    end

    let(:ipv6hint) do
      Resolv::DNS::SvcParams.new(
        [
          Resolv::DNS::SvcParam::IPv6Hint.new(%w[2001:db8::1])
        ]
      )
    end

    it 'could to_s' do
      expect(ipv6hint.to_s).to eq 'ipv6hint=2001:db8::1'
    end

    let(:dohpath) do
      Resolv::DNS::SvcParams.new(
        [
          Resolv::DNS::SvcParam::DoHPath.new('/dns-query{?dns}')
        ]
      )
    end

    it 'could to_s' do
      expect(dohpath.to_s).to eq 'dohpath=/dns-query{?dns}'
    end
  end
end
# rubocop: enable Metrics/BlockLength
