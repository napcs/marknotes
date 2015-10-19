# DashboardController provides the backend for the user's dashboard.
class DashboardController < ApplicationController
  before_action :authenticate_user!

  def show
    @recent_notes = current_user.notes.visible.order("updated_at DESC").limit(5)
    @most_used_tags = current_user.tags.most_used(5)
  end
end
