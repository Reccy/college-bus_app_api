require 'sinatra'
require 'base64'
require 'json'
require 'yaml'
require 'pg'

# Setup connection to the Postgres Database
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
    res = nil
    conn = PG.connect(ENV['DATABASE_URL'])
    conn.transaction do |conn|
        res = conn.exec "SELECT * FROM kvp WHERE key = 'bus_routes';"
    end
    conn.close
    
    return "empty" if res.nil?
    
    res = Base64.decode64(res[0]['value'])
    
    status 200
    return res
end

post '/bus_routes' do
    begin
        json = JSON.parse(unescape(request.body.read.to_s))
        
        writeval = Base64.encode64(json.to_json);
        
        conn = PG.connect(ENV['DATABASE_URL'])
        conn.transaction do |conn|
            conn.exec "DELETE FROM kvp WHERE key = 'bus_routes';"
            conn.exec "INSERT INTO kvp VALUES('bus_routes','#{writeval}');"
        end
        conn.close
        
        status 200
        return json.to_json
    rescue StandardError => err
        status 500
        return "{\"success\":\"false\", \"error\":" + err.to_s + "}"
    end
end

get '/bus_stops' do
    res = nil
    conn = PG.connect(ENV['DATABASE_URL'])
    conn.transaction do |conn|
        res = conn.exec "SELECT * FROM kvp WHERE key = 'bus_stops';"
    end
    conn.close
    
    return "empty" if res.nil?
    
    res = Base64.decode64(res[0]['value'])
    
    status 200
    return res
end

post '/bus_stops' do
    begin
        json = JSON.parse(unescape(request.body.read.to_s))
        
        writeval = Base64.encode64(json.to_json);
        
        conn = PG.connect(ENV['DATABASE_URL'])
        conn.transaction do |conn|
            conn.exec "DELETE FROM kvp WHERE key = 'bus_stops';"
            conn.exec "INSERT INTO kvp VALUES('bus_stops','#{writeval}');"
        end
        conn.close
        
        status 200
        return json.to_json
    rescue StandardError => err
        status 500
        return "{\"success\":\"false\", \"error\":" + err.to_s + "}"
    end
end

get '/route_waypoints/:route' do
    route_name = params[:route]
    
    key = "bus_waypoints_#{route_name}"
    
    res = nil
    conn = PG.connect(ENV['DATABASE_URL'])
    conn.transaction do |conn|
        res = conn.exec "SELECT * FROM kvp WHERE key = '#{key}';"
    end
    conn.close
    
    return "empty" if res.nil?
    
    res = Base64.decode64(res[0]['value'])
    
    status 200
    return res
end

post '/route_waypoints' do
    begin
        json = JSON.parse(unescape(request.body.read.to_s))
        
        internal_id = json['internal_id']
        waypoints = json['waypoints']
        writekey = "bus_waypoints_#{internal_id}"
        writeval = Base64.encode64(waypoints.to_json)
        
        conn = PG.connect(ENV['DATABASE_URL'])
        conn.transaction do |conn|
            conn.exec "DELETE FROM kvp WHERE key = '#{writekey}';"
            conn.exec "INSERT INTO kvp VALUES('#{writekey}','#{writeval}');"
        end
        conn.close
        
        status 200
        return json.to_json
    end
    return 
end