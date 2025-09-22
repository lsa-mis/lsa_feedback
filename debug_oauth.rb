#!/usr/bin/env ruby
# Debug script for FeedbackGem OAuth configuration
# Run with: rails runner debug_oauth.rb

puts "=== FeedbackGem OAuth Debug ==="
puts

begin
  # Load the configuration
  config = FeedbackGem.configuration

  puts "Configuration loaded successfully!"
  puts "Debug info: #{config.debug_info}"
  puts

  # Test OAuth client initialization
  puts "Testing OAuth client initialization..."
  oauth_client = FeedbackGem::OAuthClient.new(config)
  puts "OAuth client initialized successfully!"
  puts

  # Test token request
  puts "Testing OAuth token request..."
  token = oauth_client.get_access_token
  puts "Token retrieved successfully: #{token[0..10]}..."
  puts

  # Test ticket client
  puts "Testing ticket client initialization..."
  ticket_client = FeedbackGem::TicketClient.new(config)
  puts "Ticket client initialized successfully!"
  puts

  puts "✅ All tests passed! Your OAuth configuration is working correctly."

rescue => e
  puts "❌ Error: #{e.message}"
  puts
  puts "Debug information:"
  puts "- Error class: #{e.class}"
  puts "- Backtrace:"
  puts e.backtrace.first(5).map { |line| "  #{line}" }
  puts
  puts "Common issues:"
  puts "1. Check that your Rails credentials are properly configured"
  puts "2. Verify your TDX OAuth credentials are correct"
  puts "3. Ensure your TDX instance URLs are correct"
  puts "4. Check that your client has the 'tdxticket' scope"
end
