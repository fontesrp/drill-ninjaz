class DrillGroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!, only: [:destroy, :create, :edit, :update]

  def index
    @drill_groups = DrillGroup.all
  end

  def show
    @drill_group = DrillGroup.find params.require(:id)
    @question = Question.new
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

    # TODO: test create question form (creat a questions controller)
  end

  def edit
    @drill_group = DrillGroup.find params.require(:id)
  end

  def update
    @drill_group = DrillGroup.find params.require(:id)

    if @drill_group.update drill_group_params
      redirect_to drill_group_path(@drill_group)
    else
      render :edit
    end
  end

  def destroy
    @drill_group = DrillGroup.find params.require(:id)
    if @drill_group.destroy
      redirect_to drill_groups_path
    else
      flash.now[:alert] = 'Cannot delete'
      render :index
    end
  end

  private

  def drill_group_params
    params.require(:drill_group).permit(:name, :description, :level, :points)
  end

  def authorize_user!
    unless can?(:manage, @drill_group)
      flash[:alert] = 'Access Denied!'
      redirect_to drill_group_path(@attempt.drill_group)
    end
  end
end
