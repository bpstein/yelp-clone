require 'rails_helper'

feature 'reviewing' do
  before do
    visit '/restaurants'
    expect(current_path).to eq('/restaurants')
    click_link('Sign up')
    fill_in('Email', with: 'user@email.com')
    fill_in('Password', with: 'bananas')
    fill_in('Password confirmation', with: 'bananas')
    click_button('Sign up')
    Restaurant.create(name: 'KFC')
  end
  
  scenario 'allows users to leave a review using a form' do
     visit '/restaurants'
     click_link 'Review KFC'
     fill_in "Thoughts", with: "so so"
     select '3', from: 'Rating'
     click_button 'Leave Review'

     expect(current_path).to eq '/restaurants'
     expect(page).to have_content('so so')
  end

end