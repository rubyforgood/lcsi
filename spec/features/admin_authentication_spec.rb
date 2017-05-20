require 'rails_helper'

RSpec.feature 'Admin Authentication', type: :feature do
  scenario 'admin login successfully' do
    Account.create!(username: "someone@example.tld", password: "somepassword", admin: true, contest: Contest.create!)
    visit root_path
    login("someone@example.tld", "somepassword")
    expect(page).to have_content "You have successfully logged in"
  end

  scenario 'admin login unsuccessfully' do
    Account.create!(username: "someone@example.tld", password: "somepassword", admin: true, contest: Contest.create!)
    visit root_path
    login("someone@example.tld", "someotherpassword")
    expect(page).to have_content "You have entered the wrong credentials"
  end

  scenario 'admin logout successfully' do
    Account.create!(username: "someone@example.tld", password: "somepassword", admin: true, contest: Contest.create!)
    visit root_path
    login("someone@example.tld", "somepassword")
    click_link "Logout"
    expect(page).to have_content "You have successfully logged out."
  end

  def login(username, password)
    fill_in "Username", with: username
    fill_in "Password", with: password
    click_button "Log in"
  end
end
