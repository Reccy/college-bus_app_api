require 'sinatra'
require 'base64'
require 'json'
require 'yaml'
require 'pg'

# Setup connection to the Postgres Database
conn = nil
begin
    conn = PG.connect(ENV['DATABASE_URL'])
    conn.exec "CREATE TABLE IF NOT EXISTS kvp (key varchar PRIMARY KEY, value varchar);"
end

# Returns debug information
get '/' do
    status 200
    
    res = {'status' => 'ok'}
    return res.to_json
end

get '/bus_routes' do
    status 200
    
    res = conn.exec "SELECT * FROM kvp WHERE key = 'bus_routes';"
    res = Base64.decode64(res[0]['value'])
    
    return res
end

post '/bus_routes' do
    status 200
    begin
        json = JSON.parse(unescape(request.body.read.to_s))
        
        writeval = Base64.encode64(json.to_json);
        
        conn.exec "DELETE FROM kvp WHERE key = 'bus_routes';"
        conn.exec "INSERT INTO kvp VALUES('bus_routes','#{writeval}');"
        
        status 200
        return json.to_json
    rescue StandardError => err
        status 500
        return "{\"success\":\"false\", \"error\":" + err.to_s + "}"
    end
end

get '/bus_stops' do
    status 200
    
    res = conn.exec "SELECT * FROM kvp WHERE key = 'bus_stops';"
    res = Base64.decode64(res[0]['value'])
    
    return res
end

post '/bus_stops' do
    status 200
    begin
        json = JSON.parse(unescape(request.body.read.to_s))
        
        writeval = Base64.encode64(json.to_json);
        
        conn.exec "DELETE FROM kvp WHERE key = 'bus_stops';"
        conn.exec "INSERT INTO kvp VALUES('bus_stops','#{writeval}');"
        
        status 200
        return json.to_json
    rescue StandardError => err
        status 500
        return "{\"success\":\"false\", \"error\":" + err.to_s + "}"
    end
end
