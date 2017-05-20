require 'rails_helper'

RSpec.feature 'Account Authentication', type: :feature do
  scenario 'account login successfully' do
    Account.create!(username: "account", password: "account", contest: Contest.create!)
    visit root_path
    login("account", "account")
    expect(page).to have_content "You have successfully logged in"
  end

  scenario 'account login unsuccessfully' do
    Account.create!(username: "account", password: "accountddd", contest: Contest.create!)
    visit root_path
    login("account", "account")
    expect(page).to have_content "You have entered the wrong credentials"
  end

  scenario 'account logout successfully' do
    Account.create!(username: "account", password: "account", contest: Contest.create!)
    visit root_path
    login("account", "account")
    click_link "Logout"
    expect(page).to have_content "You have successfully logged out."
  end

  def login(username, password)
    fill_in "Username", with: username
    fill_in "Password", with: password
    click_button "Log in"
  end
end
