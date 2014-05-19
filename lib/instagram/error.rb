module Instagram
  # Custom error class for rescuing from all Instagram errors
  class Error < StandardError
    attr_reader :code
    attr_reader :message
    attr_reader :type
    attr_reader :response

    def initialize(response)
      body     = JSON.parse(response[:body], :symbolize_names => true)
      @code    = body[:code] || body[:meta][:code]
      @message = body[:error_message] || body[:meta][:error_message]
      @type    = body[:error_type] || body[:meta][:error_type]
      @response = response[:body]
    end

    def message
      "#{@type}: #{@message} (#{@code})"
    end
    alias :to_s :message
  end

  # Raised when Instagram returns the HTTP status code 400
  class BadRequest < Error; end

  # Raised when Instagram returns the HTTP status code 404
  class NotFound < Error; end

  # Raised when Instagram returns the HTTP status code 500
  class InternalServerError < Error; end

  # Raised when Instagram returns the HTTP status code 502
  class BadGateway < Error; end

  # Raised when Instagram returns the HTTP status code 503
  class ServiceUnavailable < Error; end

  # Raised when Instagram returns the HTTP status code 504
  class GatewayTimeout < Error; end

  # Raised when a subscription payload hash is invalid
  class InvalidSignature < Error; end
end
