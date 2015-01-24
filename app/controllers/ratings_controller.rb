class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_protocol, only: [:create, :update]
  before_action :set_rating, only: :update

  load_and_authorize_resource

  def create
    @rating = @protocol.ratings.new(score: params[:score], user: current_user)
    @rating_result = @rating.save
    set_globals
    respond_to do |format|
      format.js
    end
  end

  def update
    @rating_result = @rating.update_attribute(:score, params[:score])
    set_globals
    respond_to do |format|
      format.js
    end
  end

  private
  def set_protocol
    @protocol = Protocol.friendly.find(params[:protocol_id])
  end

  def set_rating
    @rating = Rating.find(params[:id])
  end

  # Setup globals used by multiple actions.
  def set_globals
    @user_rating = Rating.where(user: current_user, protocol: @protocol).first if current_user.present?
    @user_rating_score = @user_rating.try(:score)
    @average_rating_score = @protocol.average_rating
    @rating_count = @protocol.ratings.size
    @rating_path = @user_rating.present? ?
      protocol_rating_path(protocol_id: @protocol.slug, id: @user_rating.id) :
      protocol_ratings_path(protocol_id: @protocol.slug)
  end
end
