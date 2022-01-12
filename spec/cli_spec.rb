# frozen_string_literal: true

require_relative 'spec_helper'

# rubocop: disable Metrics/BlockLength
RSpec.describe Nslookupot::CLI do
  context 'Resource Record (RR) TYPEs' do
    let(:cli) do
      Nslookupot::CLI.new
    end

    it 'could return the typeclass object' do
      expect(cli.s2typeclass('A')).to eq Resolv::DNS::Resource::IN::A
      expect(cli.s2typeclass('AAAA')).to eq Resolv::DNS::Resource::IN::AAAA
      expect(cli.s2typeclass('CNAME')).to eq Resolv::DNS::Resource::IN::CNAME
      expect(cli.s2typeclass('HINFO')).to eq Resolv::DNS::Resource::IN::HINFO
      expect(cli.s2typeclass('MINFO')).to eq Resolv::DNS::Resource::IN::MINFO
      expect(cli.s2typeclass('MX')).to eq Resolv::DNS::Resource::IN::MX
      expect(cli.s2typeclass('NS')).to eq Resolv::DNS::Resource::IN::NS
      expect(cli.s2typeclass('PTR')).to eq Resolv::DNS::Resource::IN::PTR
      expect(cli.s2typeclass('SOA')).to eq Resolv::DNS::Resource::IN::SOA
      expect(cli.s2typeclass('TXT')).to eq Resolv::DNS::Resource::IN::TXT
      expect(cli.s2typeclass('WKS')).to eq Resolv::DNS::Resource::IN::WKS
      expect(cli.s2typeclass('CAA')).to eq Resolv::DNS::Resource::IN::CAA
      expect(cli.s2typeclass('SVCB')).to eq Resolv::DNS::Resource::IN::SVCB
      expect(cli.s2typeclass('HTTPS')).to eq Resolv::DNS::Resource::IN::HTTPS
    end

    it 'could raise NameError' do
      expect { cli.s2typeclass('ANY') }.to raise_error(NameError)
      expect { cli.s2typeclass('ClassValue') }.to raise_error(NameError)
      expect { cli.s2typeclass('hoge') }.to raise_error(NameError)
    end
  end
end
# rubocop: enable Metrics/BlockLength.
