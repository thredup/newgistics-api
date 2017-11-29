require "spec_helper"

RSpec.describe NewgisticsApi::Client do
  describe ".make_request" do
    it "should raise if the block passed isn't returning a Hash" do
      expect {
        subject.make_request(:post, "/") { "wrong argument type" }
      }.to raise_error(TypeError, "The output of the block must be a Hash")
    end
  end

end
