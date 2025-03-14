class StravaTokenService
  def self.refresh_token
    client_id = ENV['STRAVA_CLIENT_ID']
    client_secret = ENV['STRAVA_CLIENT_SECRET']
    refresh_token = ENV['STRAVA_REFRESH_TOKEN']
    
    unless client_id && client_secret && refresh_token
      Rails.logger.error("Missing Strava credentials: client_id, client_secret, or refresh_token")
      return nil
    end
    
    Rails.logger.info("Refreshing Strava access token...")
    
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
      
      # Store the new access token
      ENV['STRAVA_ACCESS_TOKEN'] = data['access_token']
      
      # Store the new refresh token if provided
      if data['refresh_token'].present?
        ENV['STRAVA_REFRESH_TOKEN'] = data['refresh_token']
        Rails.logger.info("Updated refresh token")
      end
      
      # Store the expiration time
      if data['expires_at'].present?
        ENV['STRAVA_TOKEN_EXPIRES_AT'] = data['expires_at'].to_s
        Rails.logger.info("Token will expire at: #{Time.at(data['expires_at'])}")
      end
      
      Rails.logger.info("Successfully refreshed Strava access token")
      return data['access_token']
    else
      Rails.logger.error("Failed to refresh Strava token: #{response.body}")
      return nil
    end
  end
  
  def self.get_current_token
    # Try to use the existing token if available
    access_token = ENV['STRAVA_ACCESS_TOKEN']
    expires_at = ENV['STRAVA_TOKEN_EXPIRES_AT'].to_i
    
    # Check if token is expired or will expire in the next 5 minutes
    if access_token.nil? || expires_at.nil? || expires_at < (Time.now.to_i + 300)
      Rails.logger.info("Token is nil or expired, refreshing...")
      access_token = refresh_token
    end
    
    access_token
  end
  
  def self.handle_expired_token(response)
    # Check if the error is due to an expired token
    if response.code.to_i == 401
      begin
        error_details = JSON.parse(response.body)
        if error_details['message']&.include?('Authorization Error')
          Rails.logger.info("Authorization error detected, refreshing token...")
          return refresh_token
        end
      rescue JSON::ParserError
        # If response body is not valid JSON, just continue
      end
    end
    
    # If we couldn't refresh the token or the error was not related to authorization
    nil
  end
end 