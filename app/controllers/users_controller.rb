class UsersController < ApplicationController
  def index
    mapping = {
      name: 'name',
      email: 'email'
    }

    render json: QueryFilter.new(:user, params, mapping).query
  end
end
