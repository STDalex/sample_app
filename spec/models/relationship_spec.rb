require 'spec_helper'

describe Relationship do

  before do
    @follower = FactoryGirl.create(:user)
    @followed = FactoryGirl.create(:user)
    @relationship = @follower.relationships.build(followed_id: @followed_id)
  end

  it "should create a new instance given valid attributes" do
    @relationship.save!
  end
end
