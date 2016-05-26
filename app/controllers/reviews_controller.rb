class ReviewsController < ApplicationController

  # before_filter :require_permission, only: :update,
  before_action :authenticate_user!
  
  def new 
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create 
    @restaurant = Restaurant.find params[:restaurant_id]
    @review = @restaurant.reviews.build_with_user review_params, current_user

    if @review.save
      redirect_to restaurants_path
    else
      if @review.errors[:user]
        redirect_to restaurants_path, alert: 'You have already reviewed this restaurant'
      else
        render :new
      end
    end
  end

  def review_params 
    params.require(:review).permit(:thoughts, :rating)
  end

  def update 
    # @restaurant = Restaurant.find params[:restaurant_id]
    # @review = @restaurant.reviews.build_with_user review_params, current_user

    # if @review.save
    #   redirect_to restaurants_path
    # else
    #   if @review.errors[:user]
    #     redirect_to restaurants_path, alert: 'This is not your review'
    #   else
    #     render :new
    #   end
    # end
  end 

  # def delete 
  #   @restaurant = Restaurant.find params[:restaurant_id]
  #   @review = @restaurant.reviews.build_with_user review_params, current_user
  # end

end
