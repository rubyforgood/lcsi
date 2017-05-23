require 'rails_helper'

RSpec.feature 'administrator can create accounts', type: :feature do
  include_context "a configured contest"
  include_context "an authorized admin"

  scenario "an admin can create new accounts" do
    visit admin_contest_path

    click_on "Manage Accounts"

    accounts = [{ name: "A quick and speedy account", username: "roadrunner" },
             { name: "Move fast and break things", username: "hare" },
             { name: "Slow and steady", username: "tortise" }]

    accounts.each do |t|
      click_on "Add New Account"

      fill_in "Name", with: t[:name]
      fill_in "Username", with: t[:username]

      click_on "Create Account"
    end

    expect(Contest.instance.accounts.count).to eq 5

    accounts.each do |t|
      expect(page).to have_content t[:name]
    end
  end

end
