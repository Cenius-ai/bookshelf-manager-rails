module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :authenticate_admin!

    layout "application"
  end
end
