class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def show
    @git_message = `git show --pretty=%H`
  end
end
