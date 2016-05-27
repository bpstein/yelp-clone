require 'rails_helper'

feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
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

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    before do 
      visit '/restaurants'
      click_link('Sign up')
      fill_in('Email', with: 'user@email.com')
      fill_in('Password', with: 'bananas')
      fill_in('Password confirmation', with: 'bananas')
      click_button('Sign up')
    end

    scenario 'prompts a registered user to fill out a form, then displays the new restaurant' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end
  end

  context 'an invalid restaurant' do
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

    it 'does not let you submit a name that is too short' do
      visit '/'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'kf'
      click_button 'Create Restaurant'
      expect(page).not_to have_css 'h2', text: 'kf'
      expect(page).to have_content 'error'
    end
  end

  context 'viewing restaurants' do
    let!(:kfc) { Restaurant.create(name:'KFC') }

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do 

    before do 
      Restaurant.create name: 'KFC' 
      visit '/'
      click_link('Sign up')
      fill_in('Email', with: 'user@email.com')
      fill_in('Password', with: 'bananas')
      fill_in('Password confirmation', with: 'bananas')
      click_button('Sign up')
    end
    

    scenario 'allows a user to edit their own restaurant' do 
      visit '/'
      click_link('Add a restaurant')
      fill_in('Name', with: 'Pizza Joint')
      click_button 'Create Restaurant'
      click_link 'Edit Pizza Joint'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      fill_in 'Description', with: 'Deep fried goodness'
      click_button 'Update Restaurant'
      expect(page).to have_content 'KFC'
      expect(page).not_to have_content 'This is not your Restaurant!'
    end

    scenario "prevents a user from editing someone else's restaurant" do 
      visit '/'
      click_link 'Edit KFC'
      expect(page).to have_content 'This is not your Restaurant!'
      expect(current_path).to eq '/restaurants'
    end
  end


  context 'deleting restaurants' do
    before do
      visit '/restaurants'
      expect(current_path).to eq('/restaurants')
      click_link('Sign up')
      fill_in('Email', with: 'user@email.com')
      fill_in('Password', with: 'bananas')
      fill_in('Password confirmation', with: 'bananas')
      click_button('Sign up')
      Restaurant.create(name: 'Pizza Place')
    end

    scenario 'removes a restaurant when a user clicks a delete link' do
      visit '/restaurants'
      click_link('Add a restaurant')
      fill_in('Name', with: 'Pizza Joint')
      click_button 'Create Restaurant'
      click_link 'Delete Pizza Joint'
      expect(page).not_to have_content 'Pizza Joint'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario "prevents a user from editing someone else's restaurant" do 
      visit '/'
      click_link 'Delete Pizza Place'
      expect(page).to have_content 'This is not your Restaurant!'
      expect(current_path).to eq '/restaurants'
    end
  end

end