# USD/ARS Exchange Rate API

require 'sinatra'
require 'nokogiri'
require 'open-uri'

get '/' do
  doc = Nokogiri::HTML(open('http://dolarhoy.com/cotizacion-dolar'))

  last_update_text = "#{doc.at_css('.update').text} -0300"
  usd_buy_rate = doc.at_css('.compra').text.strip[-5..-1].sub!(',', '.').to_f
  usd_sell_rate = doc.at_css('.venta').text.strip[-5..-1].sub!(',', '.').to_f

  last_update_datetime = DateTime.strptime(last_update_text, '%d/%m/%y %H:%M %z')

  content_type :json

  json = {
    last_update: last_update_datetime.to_s,
    usd_buy_rate: usd_buy_rate,
    usd_sell_rate: usd_sell_rate
  }.to_json
end
