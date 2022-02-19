class WeatherController < ApplicationController
	require 'net/http'
	require 'uri'
    require 'json'

	def ip_address
			ip = Net::HTTP.get(URI("https://ip-fast.com/api/ip/?format=json&location=True"))
	end

	def location
		location_uri = URI('https://geocode.xyz')
	    params = { 
	      'locate' => ip_address,
	      'json' => 1,
	      'region' => 'US',
	      'moreinfo' => 1
	    }
	     location_uri.query = URI.encode_www_form(params)
	     location_response = Net::HTTP.get_response(location_uri)
	     location = location_response.read_body
	     location_hash = JSON.parse(location)
	end
  
    def weather
    	timezone = location['timezone'] 
    	long = location['longt'] 
    	latt = location['latt']
    	puts "11111111111111"
    	puts timezone
      weather_uri = URI('https://api.open-meteo.com/v1/forecast?')
      params = {
  	  'latitude' => latt,
  	  'longitude' => long,
  	  'hourly' => 'temperature_2m',
  	  'daily' => ['temperature_2m_max','temperature_2m_min'],
  	  'timezone' => timezone,
  	  'temperature_unit' => 'fahrenheit'
  	  }
     weather_uri.query = URI.encode_www_form(params)
     weather_response = Net::HTTP.get_response(weather_uri)

     weather = weather_response.read_body
     weather_hash = JSON.parse(weather)
    end

    def daily_hash
   	   weather["daily"]
    end

    def final 
       puts "!!!!!!!!!!!!!!!!!!!!!!!"
       high = daily_hash["temperature_2m_max"]
       puts high
	   low = daily_hash["temperature_2m_min"]
	   puts low
       time = daily_hash["time"]
	   puts time
	   x = []
	    while low.length() != 0  
	       x.append("#{time.shift} High:#{high.shift} 
	      Low:#{low.shift}")
	   end 

	   x
	end
    
    def get_chart 
    	high = daily_hash["temperature_2m_max"].join(",")
	    low = daily_hash["temperature_2m_min"].join(",")
	    time = daily_hash['time'] 
        chart_uri = URI('https://image-charts.com/chart?')
        params = {
          'cht' => 'bvg',
          'chd' => 't:' + high + '|' + low,
          'chs' => '700x125',
          'chf' => 'b0,ls,0,72BD60,.3,517D47,.1|b1,ls,0,2F5627,.3,E67233,.1'
        }
        chart_uri.query = URI.encode_www_form(params)
        # chart_response = Net::HTTP.get_response(chart_uri)
        # @chart = chart_response.read_body
	end

    def forecast
         # @location = location
         # @weather = weather
         # @daily_hash = daily_hash
         @high = daily_hash["temperature_2m_max"]
         # @low = daily_hash["temperature_2m_min"]
         # @time = daily_hash["time"]
         # @final = final
         # @chart = get_chart
    end

#     <% @final.each do |t| %>
# 	<h2> <%= t %> </h2>
# <% end %>

#  <img src="https://image-charts.com/chart?<%= @chart %> "/>

 
end
