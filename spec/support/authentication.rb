shared_context "an authorized admin" do
  let(:admin) { Account.create! username: "proctor", password: 'asdf123', admin: true, contest: Contest.create! }

  before do
    visit "/login"
    fill_in "Username", with: admin.username
    fill_in "Password", with: admin.password

    click_on "Log in"
  end

end
