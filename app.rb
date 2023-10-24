require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

API_URL = "https://api.exchangerate.host/"
API_KEY = ENV.fetch('EXCHANGE_RATE_KEY')

get '/' do
  response = HTTP.get("#{API_URL}/list?access_key=#{API_KEY}")

  begin
    data = JSON.parse(response.to_s)
    @currencies = data["currencies"].keys
    erb(:currency_list)
  rescue
    halt 500, "Error fetching currency data"
  end
end

get '/currencies' do
  response = HTTP.get("#{API_URL}/list?access_key=#{API_KEY}")

  begin
    data = JSON.parse(response.to_s)
    @currencies = data["currencies"].keys
    erb(:currency_list)
  rescue
    halt 500, "Error fetching currency data"
  end
end

get '/:currency' do
  response = HTTP.get("#{API_URL}/list?access_key=#{API_KEY}")

  begin
    data = JSON.parse(response.to_s)
    @primary_currency = params[:currency]
    @currencies = data["currencies"].keys - [@primary_currency] # Exclude the primary currency
    erb(:conversion_options)
  rescue
    halt 500, "Error fetching currency data"
  end
end

get '/:currency/:target_currency' do
  from_currency = params[:currency]
  to_currency = params[:target_currency]
  response = HTTP.get("#{API_URL}/convert?access_key=#{API_KEY}&from=#{from_currency}&to=#{to_currency}&amount=1")

  begin
    data = JSON.parse(response.to_s)
    @result = data["result"]
    @from_currency = from_currency
    @to_currency = to_currency
    erb(:convert_result)
  rescue
    halt 500, "Error converting currency"
  end
end
