Rails.application.routes.draw do
  root 'bot#index'

  get 'bot/callback' => 'bot#callback'
  get 'bot/nav' => 'bot#nav'
  get 'bot/user_recent_media' => 'bot#user_recent_media'
  get 'bot/user_followed_by' => 'bot#user_followed_by'
  get 'bot/user_follows' => 'bot#user_follows'
end
