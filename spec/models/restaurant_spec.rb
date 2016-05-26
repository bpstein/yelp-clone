require 'spec_helper'

describe Restaurant, type: :model do

  it { is_expected.to have_many :reviews }

  it 'is not valid with a name of less than three characters' do
    restaurant = Restaurant.new(name: "kf")
    expect(restaurant).to have(1).error_on(:name)
    expect(restaurant).not_to be_valid
  end

  it "is not valid unless it has a unique name" do
    Restaurant.create(name: "Moe's Tavern")
    restaurant = Restaurant.new(name: "Moe's Tavern")
    expect(restaurant).to have(1).error_on(:name)
  end

end

describe 'reviews' do
  describe 'build_with_user' do

    let(:user) { User.create email: 'test@test.com' }
    let(:restaurant) { Restaurant.create name: 'Test' }
    let(:review_params) { {rating: 5, thoughts: 'yum'} }

    subject(:review) { restaurant.reviews.build_with_user(review_params, user) }

    it 'builds a review' do
      expect(review).to be_a Review
    end

    it 'builds a review associated with the specified user' do
      expect(review.user).to eq user
    end
  end
end

# describe 'deleted restaurants' do 

#   it 'deletes a restaurant' do 
#     user1 = User.create(email: 'test1@test.com')
#     user2 = User.create(email: 'test2@test.com')
#     restaurant = Restaurant.new(name: 'Italian'))
#     restaurant.user << user1
#     restaurant.save
#     # expect {restaurant.user}.to raise_error
#   end

# end