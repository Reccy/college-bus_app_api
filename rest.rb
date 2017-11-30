require 'sinatra'
require 'yaml'

current_latitude = ''
current_longitude = ''
current_route = '';

# POST /bus_position
# Updates the last posted bus position
post '/api/bus_position' do
    begin
        bodyJSON = JSON.parse(unescape(request.body.read.to_s))
        current_latitude = bodyJSON['latitude']
        current_longitude = bodyJSON['longitude']
        
        status 200
        body "{\"success\":\"true\",\"bus_position\":{\"latitude\":\"" + current_latitude + "\",\"longitude\":\"" + current_longitude + "\"}}"
    rescue StandardError => err
        status 500
        body "{\"success\":\"false\"}"
    end
end

# GET /bus_position
# Returns the last posted bus position
get '/api/bus_position' do
    begin
        if current_latitude == '' or current_longitude == '' then
            status 202
            body "{\"success\":\"false\",\"error_message\":\"Coordinates not yet POSTed.\"}"
        else
            status 200
            body "{\"success\":\"true\",\"bus_position\":{\"latitude\":\"" + current_latitude + "\",\"longitude\":\"" + current_longitude + "\"}}"
        end
    rescue StandardError => err
        status 500
        body "{\"success\":\"false\"}"
    end
end

# POST /bus_route
# Updates the bus's current route
post '/api/bus_route' do
    begin
        bodyJSON = JSON.parse(unescape(request.body.read.to_s))
        
        current_route = bodyJSON;
        
        status 200
        body "{\"success\":\"true\",\"route\":" + current_route.to_json + "}"
    rescue StandardError => err
        status 500
        body "{\"success\":\"false\",\"error_message\":\"" + err.to_s + "\"}"
    end
end

# GET /bus_route
# Returns the bus's current route
get '/api/bus_route' do
    begin
        if current_route == '' then
            status 202
            body "{\"success\":\"false\",\"error_message\":\"Route not yet POSTed.\"}"
        else
            status 200
            body "{\"success\":\"true\",\"route\":" + current_route.to_json + "}"
        end
    rescue StandardError => err
        status 500
        body "{\"success\":\"false\",\"error_message\":\"" + err.to_s + "\"}"
    end
end

# Unescapes a string
def unescape(s)
  YAML.load(%Q(---\n"#{s}"\n))
end
