# frozen_string_literal: true

module Nslookupot
  module Error
    # Generic error, common for all classes under Nslookupot::Error module.
    class Error < StandardError; end

    class DNNotFound < Error; end

    class DoTServerUnavailable < Error; end
  end
end
