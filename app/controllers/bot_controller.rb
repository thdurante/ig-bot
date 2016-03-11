class BotController < ApplicationController
  CLIENT_ID = '9f82bc498040497a812499f5ff3c0327'
  REDIRECT_URL = 'http://localhost:3000/bot/callback'
  USER_ID = '178254006'

  def index
    redirect_to  "https://api.instagram.com/oauth/authorize/?client_id=#{CLIENT_ID}&redirect_uri=#{REDIRECT_URL}&response_type=code&scope=follower_list+likes+public_content"
  end

  def callback
    response = Instagram.get_access_token(params[:code], redirect_uri: REDIRECT_URL)
    session[:access_token] = response.access_token
    redirect_to '/bot/nav'
  end

  def nav

  end

  def user_recent_media
    @client = Instagram.client(access_token: session[:access_token])
  end

  def user_followed_by

    # Mod acces_token with extra privileges
    session[:access_token] = '1591698426.1677ed0.cb788d75009d4179ad1578e63079909b'
    final_result = []

    # First Http request - fetch first 50 items by default - Only works if user is unlocked
    uri = URI.parse("https://api.instagram.com/v1/users/#{USER_ID}/followed-by?access_token=#{session[:access_token]}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    res = http.request(Net::HTTP::Get.new(uri.request_uri))
    next_page = JSON.parse(res.body)['pagination']['next_url']

    final_result.concat(JSON.parse(res.body)['data'])

    # Remaining Http requests - fetch 50 items each iteration - Only works if user is unlocked
    while !(next_page.nil?) do
      uri = URI.parse(next_page)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      res = http.request(Net::HTTP::Get.new(uri.request_uri))

      final_result.concat(JSON.parse(res.body)['data'])

      next_page = JSON.parse(res.body)['pagination']['next_url']
    end

    @response = final_result

    # Client info
    uri = URI.parse("https://api.instagram.com/v1/users/#{USER_ID}/?access_token=#{session[:access_token]}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    res = http.request(Net::HTTP::Get.new(uri.request_uri))

    @user_info = JSON.parse(res.body)

  end

  def user_follows

    # Mod acces_token with extra privileges
    session[:access_token] = '1591698426.1677ed0.cb788d75009d4179ad1578e63079909b'
    final_result = []

    # First Http request - fetch first 50 items by default - Only works if user is unlocked
    uri = URI.parse("https://api.instagram.com/v1/users/#{USER_ID}/follows?access_token=#{session[:access_token]}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    res = http.request(Net::HTTP::Get.new(uri.request_uri))
    next_page = JSON.parse(res.body)['pagination']['next_url']

    final_result.concat(JSON.parse(res.body)['data'])

    # Remaining Http requests - fetch 50 items each iteration - Only works if user is unlocked
    while !(next_page.nil?) do
      uri = URI.parse(next_page)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      res = http.request(Net::HTTP::Get.new(uri.request_uri))

      final_result.concat(JSON.parse(res.body)['data'])

      next_page = JSON.parse(res.body)['pagination']['next_url']
    end

    @response = final_result

    # Client info
    uri = URI.parse("https://api.instagram.com/v1/users/#{USER_ID}/?access_token=#{session[:access_token]}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    res = http.request(Net::HTTP::Get.new(uri.request_uri))

    @user_info = JSON.parse(res.body)

  end
end
