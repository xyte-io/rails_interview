class CommentsController < ApplicationController
  def index
    mapping = {
      content: 'content',
      user_name: 'user.name',
      user_email: 'user.email'
    }

    render json: QueryFilter.new(:comment, params, mapping).query.includes(:user)
  end
end
