require 'rubygems'
require 'sinatra'
require 'yaml'

# GET '/'
# Returns status 200 & ok indicating that the server is running.
get '/' do
    status 200
    res = {'status' => 'ok'}
    return res.to_json
end
