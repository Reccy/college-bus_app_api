require 'sinatra'

coords = ''

# POST /bus_position
# Updates the last posted bus position
post '/api/bus_position' do
    coords = request.body.read
end

# GET /bus_position
# Returns the last posted bus position
get '/api/bus_position' do
    coords
end