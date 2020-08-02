require 'rails_helper'

feature 'User can register', %q{
  In order to сreate an account
  As an unauthenticated user
  I'd like to be able to sign up
} do

  given(:user) {create(:user)}

  background { visit new_user_registration_path }

  scenario 'Registered user tries to sing up' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'Unregistered user tries to sing up' do
    fill_in 'Email', with: 'user@gmail.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregistered user tries to sing up with error' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end
end
