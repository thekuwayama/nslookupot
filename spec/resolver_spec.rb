# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe Nslookupot::Resolver do
  context '(DNS over TLS)' do
    let(:resolver) do
      Nslookupot::Resolver.new
    end

    let(:sock) do
      sock = SimpleStream.new
      bin = "\x00\x2d\x00\x00\x81\x80\x00\x01\x00\x01\x00\x00\x00\x00\x07\x65" \
            "\x78\x61\x6d\x70\x6c\x65\x03\x63\x6f\x6d\x00\x00\x01\x00\x01\xc0" \
            "\x0c\x00\x01\x00\x01\x00\x01\x18\xb3\x00\x04\x5d\xb8\xd8\x22"
      sock.write(bin)

      sock
    end

    it 'could resolve `example.com` with #getaddress' do
      allow(resolver).to receive(:gen_sock).and_return(sock)
      allow(resolver).to receive(:send_msg)

      expect(resolver.resolve_address('example.com'))
        .to eq Resolv::IPv4.create('93.184.216.34')
    end
  end
end
