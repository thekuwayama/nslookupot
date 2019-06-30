# frozen_string_literal: true

RSpec.configure(&:disable_monkey_patching!)

require 'nslookupot'

class SimpleStream
  def initialize(binary = '')
    @buffer = binary
  end

  def write(binary)
    @buffer += binary
  end

  def read(len = @buffer.length)
    res = @buffer.slice(0, len)
    @buffer = @buffer[len..]
    res
  end

  def close
    @buffer = nil
  end
end
