class StravaTokenService
  def self.refresh_token
    client_id = ENV['STRAVA_CLIENT_ID']
    client_secret = ENV['STRAVA_CLIENT_SECRET']
    refresh_token = ENV['STRAVA_REFRESH_TOKEN']
    
    return unless client_id && client_secret && refresh_token
    
    response = HTTParty.post(
      "https://www.strava.com/oauth/token",
      body: {
        client_id: client_id,
        client_secret: client_secret,
        refresh_token: refresh_token,
        grant_type: 'refresh_token'
      }
    )
    
    if response.success?
      data = JSON.parse(response.body)
      
      # Store the new access token and refresh token
      # In a real production app, you would store these securely
      # For Render, we're using environment variables
      ENV['STRAVA_ACCESS_TOKEN'] = data['access_token']
      
      # If you have a way to update environment variables on Render
      # You could update the refresh token as well
      # ENV['STRAVA_REFRESH_TOKEN'] = data['refresh_token']
      
      return data['access_token']
    else
      Rails.logger.error("Failed to refresh Strava token: #{response.body}")
      return nil
    end
  end
  
  def self.get_current_token
    # Try to use the existing token if available
    access_token = ENV['STRAVA_ACCESS_TOKEN']
    
    # If no token exists or it's expired, refresh it
    if access_token.nil?
      access_token = refresh_token
    end
    
    access_token
  end
end 