class DashboardController < ApplicationController
  # Your Strava access token
  # Note: For full functionality, your token needs the following scopes:
  # - read (for athlete profile)
  # - read_all (for detailed athlete stats)
  
  # Token is now managed by StravaTokenService
  # which handles refreshing the token when needed
  
  def index
    @last_updated = Time.now
    access_token = StravaTokenService.get_current_token
    @strava_service = StravaService.new(access_token)
    @error = nil
    @stats_error = nil
    @athlete = nil
    @athlete_stats = {}
    @sport_type = params[:sport_type] || 'ride' # Default to cycling
    
    begin
      # Fetch athlete data
      Rails.logger.debug "Fetching athlete data..."
      @athlete = @strava_service.athlete
      Rails.logger.debug "Athlete data: #{@athlete.inspect}"
      
      if @athlete && @athlete['id'].present?
        # Fetch athlete stats
        begin
          Rails.logger.debug "Fetching athlete stats for ID: #{@athlete['id']}"
          @athlete_stats = @strava_service.athlete_stats(@athlete['id'])
          Rails.logger.debug "Athlete stats: #{@athlete_stats.inspect}"
          
          # Check if stats contain any data
          if @athlete_stats.empty? || (@athlete_stats['all_ride_totals'].nil? && @athlete_stats['all_run_totals'].nil?)
            @stats_error = "Could not retrieve athlete stats. Your token may not have the required permissions."
            Rails.logger.error "Stats error: #{@stats_error}"
          end
          
          # Convert total distance from meters to kilometers for display
          if @athlete_stats['all_ride_totals'] && @athlete_stats['all_ride_totals']['distance']
            @total_distance_km = (@athlete_stats['all_ride_totals']['distance'] / 1000.0).round(1)
          end
        rescue => e
          @stats_error = "Error fetching athlete stats: #{e.message}"
          Rails.logger.error "Stats error: #{e.message}"
          Rails.logger.error e.backtrace.join("\n")
        end
      else
        @error = "Could not retrieve athlete data. Please check your access token."
        Rails.logger.error "Athlete error: #{@error}"
      end
    rescue => e
      @error = "Error: #{e.message}"
      Rails.logger.error "General error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end
end 