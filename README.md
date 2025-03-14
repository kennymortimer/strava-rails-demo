# Strava Dashboard App

A Ruby on Rails application that displays your Strava athlete profile, statistics, and recent activities using the Strava API.

## Features

- Display athlete profile information
- Show lifetime and year-to-date statistics for cycling, running, and swimming
- List recent activities with details
- Responsive design that works on desktop and mobile devices
- Customizable themes with light/dark mode and color options
- Share image generation for social media

## Requirements

- Ruby 3.0.0 or higher
- Rails 7.1.3 or higher
- A Strava account and API access token
- PostgreSQL (for production environment)

## Setup

1. Clone this repository
2. Install dependencies:
   ```
   bundle install
   ```
3. Set up the database:
   ```
   rails db:create
   rails db:migrate
   ```
4. Get your Strava API access token:
   - Go to [Strava API Settings](https://www.strava.com/settings/api)
   - Create a new application or use an existing one
   - Make sure your application has the following scopes:
     - `read` (for athlete profile)
     - `activity:read` or `activity:read_all` (for activities)
     - `read_all` (for detailed athlete stats)
   - Generate an access token

5. Update the access token in the application:
   - Open `app/controllers/dashboard_controller.rb`
   - Replace `"your_strava_access_token"` with your actual token

6. Start the Rails server:
   ```
   rails server
   ```

7. Visit `http://localhost:3000` in your browser

## Deployment

### GitHub

1. Create a new repository on GitHub
2. Push your code to GitHub:
   ```
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/yourusername/strava-dashboard.git
   git push -u origin main
   ```

### Render

1. Sign up for a [Render](https://render.com/) account
2. Connect your GitHub repository to Render
3. Create a new Web Service and select your repository
4. Render will automatically detect the `render.yaml` configuration
5. Set the following environment variables in the Render dashboard:
   - `RAILS_MASTER_KEY`: Your Rails master key (from `config/master.key`)
   - `STRAVA_CLIENT_ID`: Your Strava API client ID
   - `STRAVA_CLIENT_SECRET`: Your Strava API client secret
   - `STRAVA_REFRESH_TOKEN`: Your Strava API refresh token
6. Deploy your application

## Troubleshooting

### Missing Data

If you're seeing your athlete profile but missing activities or detailed stats, your token might not have the necessary permissions. Create a new token with all required scopes as listed in the setup instructions.

### Token Expiration

Strava API tokens expire after 6 hours. If you're getting authorization errors, you may need to generate a new token.

## License

This project is open source and available under the [MIT License](LICENSE).

## Acknowledgements

- Data provided by the [Strava API](https://developers.strava.com/)
- Built with [Ruby on Rails](https://rubyonrails.org/)
