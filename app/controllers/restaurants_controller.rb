class RestaurantsController < ApplicationController

  before_action :authenticate_user!, :except => [:index, :show]
  # before_filter :require_permission, :only => [:edit, :update, :destroy]

  def index
    @restaurants = Restaurant.all
  end

  def new
     @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    @restaurant.user = current_user
    if @restaurant.save
      redirect_to '/restaurants'
    else 
      render 'new'
    end
  end

  def restaurant_params
    params.require(:restaurant).permit(:name, :description)
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit 
    @restaurant = Restaurant.find(params[:id])
    if current_user != @restaurant.user 
      redirect_to restaurants_path, alert: "This is not your Restaurant!"
    end
  end

  def update 
    @restaurant = Restaurant.find(params[:id])
    @restaurant.update(restaurant_params)
    flash[:notice] = 'Restaurant updated successfully'
    redirect_to restaurants_path  
  end

  def destroy 
    @restaurant = Restaurant.find(params[:id])
    if current_user == @restaurant.user 
      @restaurant.destroy 
      flash[:notice] = 'Restaurant deleted successfully'
      redirect_to restaurants_path
    else
      redirect_to restaurants_path, alert: "This is not your Restaurant!"
    end
  end

  # private

  # def require_permission
  #   if current_user != Restaurant.find(params[:id]).user
  #      redirect_to restaurants_path, alert: "This is not your Restaurant!"
  #    end
  # end
end
