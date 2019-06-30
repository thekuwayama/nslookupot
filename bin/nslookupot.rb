# frozen_string_literal: true

$LOAD_PATH << __dir__ + '/../lib'

require 'nslookupot'

name = ARGV[0]
resolver = Nslookupot::Resolver.new
pp resolver.resolve_address(name)
