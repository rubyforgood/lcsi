require 'rails_helper'

RSpec.describe "Admin::Accounts", type: :request do
  include_context "a configured contest"
  let(:admin) { Account.create! username: "proctor", password: 'asdf123', contest: Contest.instance, admin: true }

  describe "GET /admin/accounts" do

    before do
      # I hate this so much.  Request specs should be able to test _a single
      # request_ in isolation.  Without access to the session, we are forced
      # to treat these as full integrations, with multiple page posts
      post sessions_path params: {
        session: { username: admin.username, password: admin.password }
      }
    end

    it "creates a user with an authentication token" do
      post admin_accounts_path, params: {
        account: { name: "Slow and Steady", username: "tortise" }
      }

      expect(Account.find_by(username: "tortise").password).to be_present
    end

  end
end
