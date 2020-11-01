

module Fluent
  class HttpCallbackPluginExtension 
 
    def initialize
        require 'json'
        require 'async'
        require 'async/http/internet'
        require 'async/http/endpoint'
    end 

    # Allows the Plugin to provide a Callback in an async way . This is useful for returning the SNS Message ID back to the caller optionally
    # Params
    #  - callbackURL: Whom to notify 
    #  - body: What to notify
    #  - isHttp2
    #  - mimeType 
    def dohttpcallback(callbackURL,body,isHttp2,mimeType)
    output =''

    Async do
        endpoint = Async::HTTP::Endpoint.parse(callbackURL)

        if isHttp2
            client = Async::HTTP::Client.new(endpoint, Async::HTTP::Protocol::HTTP2)
        else 
            client = Async::HTTP::Client.new(endpoint)
        end

        headers = [['Content-Type', mimeType],['Accept','*/*']]
       
        response = client.post(endpoint.path, headers, body)

        responsebody = response.read
        
        output=response.status.to_s + " | " +  (responsebody.nil? || responsebody.empty? ? "" : responsebody.to_s)

    ensure
        client.close if client
    end
    
    output 
    
   end  # method
  end # Clazz level
end