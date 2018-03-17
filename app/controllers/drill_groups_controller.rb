class DrillGroupsController < ApplicationController
  def index
  end

  def show
    @drill_group = DrillGroup.find params.require(:id)
  end

  def new
    @drill_group = DrillGroup.new
  end

  def create
    @drill_group = DrillGroup.new drill_group_params
    @drill_group.user = current_user

    if @drill_group.save
      redirect_to drill_group_path(@drill_group)
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def drill_group_params
    params.require(:drill_group).permit(:name, :description, :level, :points)
  end
end
