class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: %i[show edit update destroy]
  
  def index
    @tasks = current_user.tasks.order(created_at: :desc).page(params[:page])
  end

  def show
  end

  def new
    # @task = Task.new はUserに紐づいていないのでわかりにくい
    @task = current_user.tasks.build # { content => nil, status => nil, user_id: current_user.id }  
    # @task = Task.new　{ content => nil, status => nil, user_id: nil }  
  end

  def create
    # # buildを使わない場合
    # @task = Task.new(task_params) # => { content => 'something', status => 'true', user_id: nil }  
    # @task.user_id = current_user.id
    # # buildを使う場合
    @task = current_user.tasks.build(task_params) # => { content => 'something', status => 'true', user_id: 勝手に入る }  
    # @task = Task.new(task_params)
    if @task.save
      flash[:success] = 'タスクが追加されました'
      redirect_to @task
    else
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'タスクが追加されませんでした'
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'タスクが更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクが更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy
    flash[:success] = 'タスクを削除しました'
    redirect_to tasks_url
  end
  
  
  private
  #Strong Paramater
  def task_params
    params.require(:task).permit(:content, :status)
  end

  # is_correct_user?

  def correct_user
    # 自分のtask以外は検索できないようになっている。現状で
    # @taskが見つからない= 自分の奴が見つからない -> 404ページに飛ばすことが一般的
    # https://qiita.com/zeppekipanda/items/fb1ea251197003deec12
    @task = current_user.tasks.find_by(params[:id])
    unless @task
      redirect_to root_url
    end
  end
end


