class StravaService
  require 'net/http'
  require 'json'
  
  BASE_URL = "https://www.strava.com/api/v3"
  
  def initialize(access_token)
    @access_token = access_token
  end
  
  def athlete
    response = make_request("#{BASE_URL}/athlete")
    
    if response.code.to_i == 200
      JSON.parse(response.body)
    else
      error_message = "Failed to fetch athlete data. Status: #{response.code}"
      begin
        error_details = JSON.parse(response.body)
        error_message += ", Message: #{error_details['message']}" if error_details['message']
      rescue JSON::ParserError
        # If response body is not valid JSON, just use the status code
      end
      
      Rails.logger.error error_message
      raise error_message
    end
  end
  
  def athlete_stats(athlete_id)
    response = make_request("#{BASE_URL}/athletes/#{athlete_id}/stats")
    
    if response.code.to_i == 200
      JSON.parse(response.body)
    else
      error_message = "Failed to fetch athlete stats. Status: #{response.code}"
      begin
        error_details = JSON.parse(response.body)
        error_message += ", Message: #{error_details['message']}" if error_details['message']
        
        # If we get a 401 Unauthorized, it's likely because the token doesn't have the read_all scope
        # Return a simplified stats object so the app doesn't crash
        if response.code.to_i == 401
          Rails.logger.error "#{error_message} - Returning empty stats object"
          return {
            'all_ride_totals' => nil,
            'all_run_totals' => nil,
            'all_swim_totals' => nil,
            'ytd_ride_totals' => nil,
            'ytd_run_totals' => nil,
            'ytd_swim_totals' => nil
          }
        end
      rescue JSON::ParserError
        # If response body is not valid JSON, just use the status code
      end
      
      Rails.logger.error error_message
      raise error_message
    end
  end
  
  private
  
  def make_request(url)
    uri = URI.parse(url)
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{@access_token}"
    
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end
    
    response
  end
end 