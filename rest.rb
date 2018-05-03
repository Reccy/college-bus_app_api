require 'sinatra'
require 'yaml'
require 'json'
require 'pg'


# Returns debug information
get '/' do
    status 200
    
    res = {'status' => 'ok'}
    return res.to_json
end

get '/bus_stops' do
    status 200
    
    file = File.read('db/bus_stops.json')
    res = JSON.parse(file)
    
    return res.to_json
end

# Sets the list of bus stops.
post '/bus_stops' do
    begin
        json = JSON.parse(unescape(request.body.read.to_s))
        
        File.open("db/bus_stops.json","w") do |f|
          f.write(json.to_json)
        end
        
        status 200
        return json.to_json
    rescue StandardError => err
        status 500
        return "{\"success\":\"false\", \"error\":" + err.to_s + "}"
    end
end
