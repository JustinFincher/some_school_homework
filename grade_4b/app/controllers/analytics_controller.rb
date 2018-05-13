
class AnalyticsController < ApplicationController
  def index
    @users = User.all
  end
end