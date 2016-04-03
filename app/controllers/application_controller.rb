require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    enable :sessions
    set :session_secret, "password_security"
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    erb :index
  end
####################### signup flow ##################
  get '/signup' do
    if !logged_in?
      erb :'users/create_user'
    else
      redirect to "/tweets"
    end
  end

  post '/signup' do
    if params[:username] == "" || params[:email] == "" || params[:password] == "" # && EMAIL_REGEX.match(params[:email]) check if lagit email
      redirect '/signup'
    else
      @user = User.create(username: params[:username],email: params[:email], password: params[:password])
      session[:user_id] = @user.id
      redirect "/tweets"
    end
  end



################# log in flow ###################
  get '/login' do
   erb :'users/login'
  end

  post '/login' do
    @user = User.find(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to "/tweets/tweets"
    else
      redirect to "/signup"
    end
  end
###########################################################
  get '/tweets' do
    if logged_in?
      @tweets = Tweet.all
      erb :'/tweets/tweets'
    else
      redirect '/login'
    end
  end
                 #must check password and set session

  #after logged in loads tweets.erb

  #logout will remove the session hash adn direct back to welcome page
            #you can't log out if you are not logged in
            #can not see tweets if you are not logged in

  #you can see all tweets by a selected user at /users/#{user.slug} view

  #have a link on the tweets.erb page to link to a create new tweet page  '/tweets/new'
  #after linking to the ('/tweets/new' renders create_tweet.erb) page you see a form to create a tweet or link back home
                         #//////////(maybe have a nav on every page to link around)
                         #you can only see the create tweet page if you are logged in
                         #creating a Tweet assigns that tweet to the User that created it
                         #once the form for the new tweet is submitted you are redirected.... to? you can not create a blank tweet

  #see individual tweets with /tweets/:id renders show_tweets.erb

  #there is a link here to allow you to edit   href="tweets/:id/edit"
             #a user can only submit edit  IF they are the tweet creator
             #when you edit a tweet you can not submit it without and contend     :content != ""
            #edit page is /tweets/:id/edit  it renders edit_tweet.erb once the edit form is submited you are redirected....?

  #need a "Delete Tweet" button on the /tweet/:id   erb :tweets page (uses a hidden for "DELETE" request)
                #checks if the user is the tweet creator by checking the tweet forgin key


  helpers do
    def logged_in?
      !!session[:user_id]
    end
    def current_user
      User.find(session[:user_id])
    end
  end
end
