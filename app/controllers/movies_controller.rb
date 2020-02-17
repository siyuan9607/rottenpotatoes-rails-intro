class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
     @all_ratings = Movie.rating
     if(params[:ratings] != NIL)
        session[:ratings] = params[:ratings]
     end
     if(params[:sort] != NIL)
        session[:sort] = params[:sort]
     end
     if(params[:id] != NIL)
        session[:id] = params[:id]
     end
     
     if(((params[:ratings] == NIL) && !(session[:ratings] == NIL) ) || (params[:sort] == NIL)  && !(session[:sort] == NIL))
        redirect_to movies_path("ratings" => session[:ratings], "sort" => session[:sort])
     else 
       if(params[:ratings] != NIL && params[:sort] != NIL)
         rating_array = params[:ratings].keys
         @movies = Movie.where(rating: rating_array).order(params[:sort])
       elsif(params[:sort] != NIL)
         @movies = Movie.order(params[:sort])
       else
         @movies = Movie.all
       end
     end

     instance_variable_set("@#{session[:id]}_hilite", "hilite")
  end
  
  def new
    # default: render 'new' template
  end
  
  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end
  
  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  

end
