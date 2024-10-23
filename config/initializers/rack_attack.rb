class Rack::Attack
  # Throttle requests to 5 requests per second per IP address
  throttle('req/ip', limit: 5, period: 1.second) do |req|
    req.ip
  end

  # Throttle API requests to 60 requests per minute per IP address
  throttle('api/ip', limit: 60, period: 1.minute) do |req|
    req.ip if req.path.start_with?('/api')
  end

  # Block suspicious requests
  blocklist('block suspicious requests') do |req|
    Rack::Attack::Fail2Ban.filter("ip-#{req.ip}", maxretry: 5, findtime: 1.minute, bantime: 5.minutes) do
      req.path.include?('/login') && req.post?
    end
  end
end
