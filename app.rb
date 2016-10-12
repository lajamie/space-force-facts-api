require 'json'
require 'sinatra'
require 'sinatra/activerecord'

require './config/application'
require './config/environments'

require './models/fact'

#  ____                   _    ____ ___
# |  _ \  ___   __ _     / \  |  _ \_ _|
# | | | |/ _ \ / _` |   / _ \ | |_) | |
# | |_| | (_) | (_| |  / ___ \|  __/| |
# |____/ \___/ \__, | /_/   \_\_|  |___|
#              |___/

#
# Routes/Controllers
#
get '/' do
  redirect to('http://kinduff.com/dog-api')
end

get '/api/facts' do
  content_type 'application/json', 'charset' => 'utf-8'

  facts = []
  success_response = false

  begin
    random_facts = Fact.get_random(params[:number])
    facts = random_facts.map{|f| f.body }
    success_response = true
  rescue
    success_response = false
  end

  { facts: facts, success: success_response }.to_json
end

post '/api/facts/slack' do
  content_type 'application/json', 'charset' => 'utf-8'
  random_fact = Fact.get_random().first()
  message = "*Dog Fact ##{random_fact.id}*: #{random_fact.body}\n:dog: :dog: :dog:"
  { response_type: "in_channel", text: message }.to_json
end

#
# Error handling
#
not_found do
  content_type 'text/plain'
  [404, '¯\_(ツ)_/¯']
end

error do
  content_type 'text/plain'
  [500, '(╯°□°）╯︵ ┻━┻']
end