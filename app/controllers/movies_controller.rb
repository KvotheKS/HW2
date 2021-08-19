# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController
  def index
    #"movies_temporary"
    @movies = Movie.all
    @highliter = {}
    @all_ratings = Movie.all_ratings
    #Selecting movies by ratings 
    if(params[:ratings]) then
      selected_ratings = []
      params[:ratings].each{|k,v| selected_ratings << k}
      #Changes check boxes state
      Movie.all_ratings.each do |rating|
        Movie.check_boxes[rating] = selected_ratings.include? rating
      end
    end
    @c_box = Movie.check_boxes
    @movies = @movies.select{|movie| Movie.check_boxes[movie.rating]}
      
    #sorting movies by title|release date
    if(params[:sort_by]) then
      @sort_choice = params[:sort_by]
      @movies = @movies.sort_by{|movie| movie[@sort_choice]}
      @highliter[@sort_choice] = 'hilite'
    end
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
    @movie = Movie.find params[:id]
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