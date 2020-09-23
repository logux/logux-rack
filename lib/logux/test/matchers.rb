# frozen_string_literal: true

module Logux
  module Test
    module Matchers
      autoload :SendToLogux, 'logux/test/matchers/send_to_logux'
      autoload :ResponseChunks, 'logux/test/matchers/response_chunks'
      autoload :ResponseBody, 'logux/test/matchers/response_body'
    end
  end
end
