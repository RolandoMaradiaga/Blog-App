require 'rails_helper'

RSpec.feature 'User Signup', type: :feature do
  scenario 'User signs up successfully' do
    visit new_user_registration_path

    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'

    expect(page).to have_content('Welcome to the Mini Blogging Platform')
  end
end
