require "sinatra"
require "sinatra/reloader"
require "http"
require "json"
API_KEY = ENV.fetch('EXCHANGE_RATE_KEY')

get '/' do
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_RATE_KEY"]}"
  raw_data = HTTP.get(api_url)
  raw_data_string = raw_data.to_s
  data = JSON.parse(raw_data_string)
  @currencies = data["currencies"].keys
  erb(:currency_list)
end

get '/:currency' do
  @original_currency = params.fetch("currency")
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV["EXCHANGE_RATE_KEY"]}"
  raw = HTTP.get(api_url)
  data = JSON.parse(raw.to_s)
  @currencies = data["currencies"].keys
  erb(:conversion_options)
end

get '/:currency/:target_currency' do
  @original_currency = params.fetch("currency")
  @destination_currency = params.fetch("target_currency")
  api_url = "https://api.exchangerate.host/convert?access_key=#{ENV["EXCHANGE_RATE_KEY"]}&from=#{@original_currency}&to=#{@destination_currency}&amount=1"
  response = HTTP.get(api_url)
  data = JSON.parse(response.to_s)
  @result = data["result"]
  erb(:convert_result)
end
