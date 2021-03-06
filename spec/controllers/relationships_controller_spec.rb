require 'rails_helper'

RSpec.describe RelationshipsController, type: :controller do
  before(:each) do
    @bob = create(:user)
    @medeiros = create(:user, :major)
  end

  describe "#create" do
    it "redirects to login if not logged in" do
      post :create, params: { follower_id: @bob.id, followed_id: @medeiros.id }

      expect(response).to redirect_to(login_path)
    end

    it "creates a following relationship" do
      session[:user_id] = @bob.id
      post :create, params: { follower_id: @bob.id, followed_id: @medeiros.id }

      expect(@bob.following.first).to eq(@medeiros)
    end
  end

  describe "#destroy" do
    it "redirects to login if not logged in" do
      @bob.follow(@medeiros)
      rel = Relationship.last
      post :destroy, params: { id: rel.id }

      expect(response).to redirect_to(login_path)
    end

    it "unfollows the user" do
      session[:user_id] = @bob.id
      @bob.follow(@medeiros)
      rel = Relationship.last
      post :destroy, params: { id: rel.id }

      expect(@bob.following.count).to eq(0)
    end
  end
end
