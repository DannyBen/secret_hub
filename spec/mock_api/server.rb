require 'sinatra'
require 'byebug'
require 'yaml'
require_relative '../fake_public_key'

set :port, 3000
set :bind, '0.0.0.0'

def json(hash)
  content_type :json
  JSON.pretty_generate hash
end

# Handshake
get '/' do
  json mockserver: :online
end

# Public Key
get '/repos/:owner/:repo/actions/secrets/public-key' do
  if ['matz', 'user'].include? params[:owner]
    json key: fake_public_key, key_id: 'some-key-id'
  else
    halt 404, "not found"
  end
end

# GET Secrets
get "/repos/:owner/:repo/actions/secrets" do
  if ['matz', 'user'].include? params[:owner]
    json secrets: [{ name: "PASSWORD" }, { name: "SECRET" }]
  else
    halt 404, "not found"
  end  
end

# PUT Secret
put "/repos/:owner/:repo/actions/secrets/:name" do
  if ['matz', 'user'].include? params[:owner]
    status 200
    ''
  else
    halt 500, "some error"
  end
end

# DELETE Secret
delete "/repos/:owner/:repo/actions/secrets/:name" do
  if ['matz', 'user'].include? params[:owner]
    status 200
    ''
  else
    halt 500, "some error"
  end
end

