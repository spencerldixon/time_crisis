require 'digest/sha1'

class TimeCrisis
  def initialize(app, selector: "body")
    @app = app
    @selector = selector
  end 

  def call(env)
    status, headers, response = @app.call(env)

    unless response.instance_of?(Sprockets::Asset) # Exit if we can't get the body
      document  = Nokogiri::HTML(response.body).css(@selector) # Pull out only the html we want to monitor for changes
      hash      = Digest::SHA1.hexdigest(document.to_s) # Calculate a hash from the html we pull out

      # Store the hash against the request path

      # Update timestamp if hash for path changes
      if Kredis.string(env["REQUEST_PATH"] + ":hash").value != hash
        puts "UPDATE THE DETAILS"
        Kredis.string(env["REQUEST_PATH"] + ":hash").value = hash
        Kredis.datetime(env["REQUEST_PATH"] + ":created_at").value = DateTime.current 
      end

    end

    [status, headers, response]
  end
end
