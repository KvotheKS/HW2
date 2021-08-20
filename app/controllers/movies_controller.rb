# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController
  def index
    #"movies_temporary"
    @movies = Movie.all
    @highliter = {}
    @all_ratings = Movie.all_ratings
    redirect_flag = false
    #Selecting movies by ratings 
    if(params[:ratings] && (!session[:ratings] || session[:ratings] != params[:ratings])) then
      session[:ratings] = params[:ratings]
      redirect_flag = true
    end

    if(session[:ratings]) then
      selected_ratings = []
      session[:ratings].each{|k,v| selected_ratings << k}
      #Changes check boxes state
      Movie.all_ratings.each do |rating|
        Movie.check_boxes[rating] = selected_ratings.include? rating
      end
    end

    #instance variable to check wether or not check_box is marked
    @c_box = Movie.check_boxes
    #filtering movies by rating
    @movies = @movies.select{|movie| Movie.check_boxes[movie.rating]}
    
    if(params[:sort_by] && (!session[:sort_by] || session[:sort_by] != params[:sort_by])) then
      session[:sort_by] = params[:sort_by]
      redirect_flag = true
    end
    #sorting movies by title|release date
    if(session[:sort_by]) then
      @sort_choice = session[:sort_by]
      #kind of ugly. But is necessary if sorting is to not be case dependant
      @movies = @movies.sort_by{|movie| 
        (movie[@sort_choice].is_a? String) ? movie[@sort_choice].downcase : movie[@sort_choice]}

      @highliter[@sort_choice] = 'hilite'
    end
    if(redirect_flag) then redirect_to action: index; flash.keep(:notice) end
  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
  end
   
  def new
    @movie = Movie.new
  end

  def create
    #@movie = Movie.create!(params[:movie]) #did not work on rails 5.
    @movie = Movie.create(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created!"
    flash.keep(:notice)
    redirect_to movies_path
  end

  def movie_params
    params.require(:movie).permit(:title,:rating,:description,:release_date)
  end

  def edit
    id = params[:id]
    @movie = Movie.find(id)
    #@movie = Movie.find params[:id]
  end

  def update
    redirect_flag = false
    if(params[:id] && (!session[:id] || session[:id] != params[:id])) then
      session[:id] = params[:id]
      redirect_flag = true
    end

    @movie = Movie.find session[:id]
    #@movie.update_attributes!(params[:movie])#did not work on rails 5.
    @movie.update(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated!"
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    flash[:notice] = "#{@movie.title} was deleted!"
    redirect_to movies_path
  end
end