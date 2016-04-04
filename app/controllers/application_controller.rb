require './config/environment'

class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'secret'
  end

  get '/' do
    if logged_in?
      redirect '/tweets'
    else
      erb :index
    end
  end
  ####################### signup flow ##################
  get '/signup' do
    if logged_in?
      redirect '/tweets'
    else
      erb :'/users/create_user'
    end
  end

  post '/signup' do
    if params.any? { |k, v| v.empty? }
      redirect '/signup'
    else
      @user = User.create(params)
      session[:id] = @user.id
      redirect '/tweets'
    end
  end
  ################# log in flow ###################
  get '/login' do
    if logged_in?
      redirect '/tweets'
    else
      erb :'users/login'
    end
  end

  post '/login' do
    @user = User.find_by(params)
    if @user
      session[:id] = @user.id
      redirect to '/tweets'
    else
      redirect to '/signup'
    end
  end
  ###########################################################

  get '/tweets' do#########has session[:id]
    if logged_in?
      @user = current_user
      @tweets = Tweet.all
      erb :'/tweets/tweets'
    else
      redirect '/login'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect '/login'
    else
      redirect '/tweets'
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end

  get '/tweets/new' do
    if logged_in?
      erb :'/tweets/create_tweet'
    else
      redirect '/login'
    end
  end

  post '/tweets/new' do
    if params[:content] == ""
      redirect '/tweets/new'
    else
      @tweet = Tweet.create(params)
      @tweet.user = current_user
      @tweet.save
      redirect "/tweets/#{@tweet.id}"
    end
  end

  get "/tweets/:id" do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      erb :"/tweets/show_tweet"
    else
      redirect '/login'
    end
  end
  # after linking to the ('/tweets/new' renders create_tweet.erb) page you see a form to create a tweet or link back home
  # //////////(maybe have a nav on every page to link around)
  # you can only see the create tweet page if you are logged in
  # creating a Tweet assigns that tweet to the User that created it
  # once the form for the new tweet is submitted you are redirected.... to? you can not create a blank tweet

  # see individual tweets with /tweets/:id renders show_tweets.erb

  # there is a link here to allow you to edit   href="tweets/:id/edit"
  # a user can only submit edit  IF they are the tweet creator
  # when you edit a tweet you can not submit it without and contend     :content != ""
  # edit page is /tweets/:id/edit  it renders edit_tweet.erb once the edit form is submited you are redirected....?
  get '/tweets/:id/edit' do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      erb :"/tweets/edit_tweet"
    else
      redirect '/login'
    end
  end

  post '/tweets/:id/edit' do
    if !logged_in?
      redirect '/login'
    elsif params[:content] = ''
      redirect "/tweets/#{@tweet.id}/edit"
    else
      @tweet = Tweet.find_by_id(params[:id])
      @tweet.content = params[:content]
      @tweet.save
      redirect "/tweets/#{@tweet.id}"
    end
  end

  delete '/tweets/:id/delete' do
    @tweet = Tweet.find_by_id(params[:id])
    @tweet.delete if current_user.id == @tweet.user_id
    redirect '/tweets'
  end
  # need a "Delete Tweet" button on the /tweet/:id   erb :tweets page (uses a hidden for "DELETE" request)
  # checks if the user is the tweet creator by checking the tweet forgin key
  helpers do
    def logged_in?
      !!session[:id]
    end

    def current_user
      User.find(session[:id])
    end
  end
end
