require 'sinatra'
require 'debug'
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

# GET Public Key
get '/repos/:owner/:repo/actions/secrets/public-key' do
  if %w[matz user].include? params[:owner]
    json key: fake_public_key, key_id: 'some-key-id'
  else
    halt 404, 'not found'
  end
end

# GET Org Public Key
get '/orgs/:org/actions/secrets/public-key' do
  if %w[matz user].include? params[:org]
    json key: fake_public_key, key_id: 'some-key-id'
  else
    halt 404, 'not found'
  end
end

# GET Secrets
get '/repos/:owner/:repo/actions/secrets' do
  if %w[matz user].include? params[:owner]
    json secrets: [{ name: 'PASSWORD' }, { name: 'SECRET' }]
  else
    halt 404, 'not found'
  end
end

# GET Org Secrets
get '/orgs/:org/actions/secrets' do
  if %w[matz user].include? params[:org]
    json secrets: [{ name: 'PASSWORD' }, { name: 'SECRET' }]
  else
    halt 404, 'not found'
  end
end

# PUT Secret
put '/repos/:owner/:repo/actions/secrets/:name' do
  if %w[matz user].include? params[:owner]
    status 200
    ''
  else
    halt 500, 'some error'
  end
end

# PUT Org Secret
put '/orgs/:org/actions/secrets/:name' do
  if %w[matz user].include? params[:org]
    status 200
    ''
  else
    halt 500, 'some error'
  end
end

# DELETE Secret
delete '/repos/:owner/:repo/actions/secrets/:name' do
  if %w[matz user].include? params[:owner]
    status 200
    ''
  else
    halt 500, 'some error'
  end
end

# DELETE Org Secret
delete '/orgs/:org/actions/secrets/:name' do
  if %w[matz user].include? params[:org]
    status 200
    ''
  else
    halt 500, 'some error'
  end
end
