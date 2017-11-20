require 'sinatra'
require 'yaml'

latitude=''
longitude=''

# POST /bus_position
# Updates the last posted bus position
post '/api/bus_position' do
    bodyJSON = JSON.parse(unescape(request.body.read.to_s))
    latitude = bodyJSON['latitude']
    longitude = bodyJSON['longitude']
    
    status 200
    body "{\"success\":\"true\",\"coords\":{\"latitude\":\"" + latitude + "\",\"longitude\":\"" + longitude + "\"}}"
end

# GET /bus_position
# Returns the last posted bus position
get '/api/bus_position' do
    if latitude == '' or longitude == '' then
        status 202
        body "{\"success\":\"false\",\"error_message\":\"Coordinates not yet POSTed.\"}"
    else
        status 200
        body "{\"success\":\"true\",\"coords\":{\"latitude\":\"" + latitude + "\",\"longitude\":\"" + longitude + "\"}}"
    end
end

# Unescapes a string
def unescape(s)
  YAML.load(%Q(---\n"#{s}"\n))
end