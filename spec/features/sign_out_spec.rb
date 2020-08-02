require 'rails_helper'

feature 'User can log out', %q{
  In order to log out
  As an authenticated user
  I'd like to be able to log out of my account
} do

  given(:user) {create(:user)}

  scenario 'Authenticated user tries to sing out' do
    sign_in(user)
    click_on 'Logout'

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unauthenticated user tries to sing out' do
    visit root_path

    expect(page).to_not have_content 'Logout'
  end
end
