module EncodingDotCom
  module HttpAdapters

    # Wraps the Net/HTTP library for use with the Queue.
    class NetHttpAdapter
      def initialize
        require 'net/http'
        require 'net/https'
      end

      # Makes a POST request. Raises an AvailabilityError if the
      # request times out or has other problems.
      def post(url, parameters={})
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl=true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        
        request = Net::HTTP::Post.new(uri.request_uri)
        
        puts "XML Request"
        puts parameters.inspect
        
        request.set_form_data(parameters)
        
        response = http.request(request)
      rescue => e
        raise AvailabilityError.new(e.message)
      rescue Timeout::Error => e
        raise AvailabilityError.new(e.message)          
      end
    end
    
  end
end
