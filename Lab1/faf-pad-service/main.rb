require 'active_record'
require 'pry'
require 'sucker_punch'
require 'sinatra'
require 'sinatra/json'
require 'json'
require 'logger'
require 'rest-client'

require_relative 'models/menu'
require_relative 'jobs/deliver'
require_relative 'jobs/menu_timeout'

db_config = YAML.safe_load(File.open('config/database.yml'))
ActiveRecord::Base.establish_connection(db_config)

GATEWAY_ADDRESS = 'elixir:4000/register'.freeze
IP   = ENV['IP'] || 'ruby'
PORT = ENV['PORT'] || '3000'

RestClient::Request.execute(
  method: :post,
  url: GATEWAY_ADDRESS,
  payload: { address: "#{IP}:#{PORT}" }
)

set :bind, IP
set :port, PORT

after do
  ActiveRecord::Base.clear_active_connections!
end

get '/hello' do
  json({ data: 'Hello world!' })
end

post '/menus' do
  halt(400, json({ error: 'Task limit reached' })) unless Menu.can_create_new?

  body = JSON.parse(request.body.read)
  menu = Menu.create!({ menu_type: body['menu_type'], components: [], status: 'building' })

  MenuTimeout.perform_in(MenuTimeout::AMOUNT, { id: menu.id })

  json(menu)
end

get '/menus/:id' do
  menu_id = params['id']
  halt(404, json({ error: 'Menu not found' })) unless Menu.exists?(params['id'])

  menu = Menu.find(menu_id)
  json(menu)
end

put '/menus/:id' do
  body = JSON.parse(request.body.read)
  halt(404, json({ error: 'Menu not found' })) unless Menu.exists?(params['id'])

  menu_id = params['id']
  menu = Menu.find(menu_id)
  halt(400, json({ error: 'Order has timed out' })) if menu.timed_out?
  menu.components.push(body['component'])
  menu.save

  json(menu)
end

put '/menus/:id/deliver' do
  menu_id = params['id']
  halt(404, json({ error: 'Menu not found' })) unless Menu.exists?(params['id'])

  menu = Menu.find(menu_id)
  halt(400, json({ error: 'Order has timed out' })) if menu.timed_out?
  menu.status = 'delivering'
  menu.save

  Deliver.perform_in(Deliver::DELIVERY_TIME, { id: menu.id })

  json(menu)
end

get '/status' do
  count = Menu.all.to_a.count(&:processing?)
  json({ count: count })
end
