class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  
  def index
    @tasks = Task.order(id: :desc).page(params[:page]).per(5)
  end

  def show
    set_task
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    
    if @task.save
      flash[:success] = 'タスクが追加されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクが追加されませんでした'
      render :new
    end
  end

  def edit
    set_task
  end

  def update
    set_task
    
    if @task.update(task_params)
      flash[:success] = 'タスクが更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクが更新されませんでした'
      render :edit
    end
  end

  def destroy
    set_task
    @task.destroy
    
    flash[:success] = 'タスクを削除しました'
    redirect_to tasks_url
  end
  
  private
  #Strong Paramater
  def set_task
     @task = Task.find(params[:id])
  end
  
  def task_params
    params.require(:task).permit(:content, :status)
  end
end
