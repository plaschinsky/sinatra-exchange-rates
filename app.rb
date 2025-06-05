require "sinatra"
require "sinatra/reloader"
require "http"
require "json"
require "dotenv/load"

API_URL = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}"
CONVERT_URL = "https://api.exchangerate.host/convert"

# Homepage
get("/") do
  response = HTTP.get(API_URL)
  @parsed_data = JSON.parse(response.to_s)
  erb :homepage
end

# /USD → list of "Convert 1 USD to XXX"
get("/:from_currency") do
  @original_currency = params.fetch("from_currency")
  response = HTTP.get(API_URL)
  @parsed_data = JSON.parse(response.to_s)
  erb :convert
end

# /USD/EUR → conversion result
get("/:from_currency/:to_currency") do
  @from = params.fetch("from_currency")
  @to = params.fetch("to_currency")

  response = HTTP.get("https://api.exchangerate.host/convert?from=#{@from}&to=#{@to}&amount=1&access_key=#{ENV.fetch("EXCHANGE_RATE_KEY")}")
  parsed = JSON.parse(response.to_s)
  @rate = parsed["result"]

  erb :pair
end
