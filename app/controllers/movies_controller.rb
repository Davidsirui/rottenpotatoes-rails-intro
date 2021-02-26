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
    @all_ratings = Movie.all_ratings

    sort = params[:sort] || session[:sort]
    
    set_rate_to_show()
                      
                      
    params_and_session_sort = (params[:sort].nil? && !session[:sort].nil?)
    
    if !params[:commit].nil?
       redirect_movies_path()
    end
    
    if params[:ratings].nil?
      redirect_movies_path()
    end
    
    if params_and_session_sort
      redirect_movies_path()
    end
       
    sort_order()
    
    session[:sort] = sort
    session[:ratings] = @ratings_to_show
  end
  
  def redirect_movies_path
    sort = params[:sort] || session[:sort]
    flash.keep
    redirect_to movies_path :sort => sort, :ratings => @ratings_to_show
  end
  
  # def sort_order
  #   sort = params[:sort] || session[:sort]
  #   if sort == 'title'
  #     ordering, @title_cls = {:title => :asc}, 'hilite'
  #   elsif sort == 'release_date'
  #     ordering, @release_cls = {:release_date => :asc}, 'hilite'
  #   end
  #   @movies = Movie.with_ratings(@ratings_to_show.keys).order(ordering)
  # end
  
  def sort_order
    sort = params[:sort] || session[:sort]
    if sort == 'title'
      @movies = Movie.with_ratings(@ratings_to_show.keys).order({title: :asc})
      @title_cls = 'hilite'
    elsif sort == 'release_date'
      @movies = Movie.with_ratings(@ratings_to_show.keys).order({release_date: :asc})
      @release_cls = 'hilite'
    end
    # @movies = Movie.with_ratings(@ratings_to_show.keys).order(ordering)
  end
  
  def set_rate_to_show
    @ratings_to_show = params[:ratings] || session[:ratings] \
      || Hash[@all_ratings.map { |r| [r, 1] }]
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

  # private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
end
