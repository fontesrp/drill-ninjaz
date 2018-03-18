class DrillGroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_drill_group, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:destroy, :edit, :update]
  # before_action :authorize_user!, except: [:show]

  def index
    @user = current_user
    @drill_groups = @user.drill_groups
  end

  def show
    @question = Question.new
  end

  def new
    @drill_group = DrillGroup.new
  end

  def create
    @drill_group = DrillGroup.new drill_group_params
    @drill_group.user = current_user

    if @drill_group.user.is_admin?
      if @drill_group.save
        redirect_to drill_group_path(@drill_group)
      else
        render :new
      end
    else
      flash[:alert] = 'Must be admin'
      redirect_to drill_group_tabs_path(current_user)
    end

    # TODO: test create question form (creat a questions controller)
  end

  def edit
  end

  def update
    if @drill_group.update drill_group_params
      redirect_to drill_group_path(@drill_group)
    else
      render :edit
    end
  end

  def destroy
    if @drill_group.destroy
      redirect_to drill_groups_path
    else
      flash.now[:alert] = 'Cannot delete'
      render :index
    end
  end

  private
  def find_drill_group
    @drill_group = DrillGroup.find params.require(:id)
  end

  def drill_group_params
    params.require(:drill_group).permit(:name, :description, :level, :points)
  end

  def authorize_user!
    unless can?(:crud, @drill_group)
      flash[:alert] = 'Access Denied!'
      redirect_to drill_groups_path
    end
  end
end
