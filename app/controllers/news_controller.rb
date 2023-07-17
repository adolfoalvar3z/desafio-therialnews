class NewsController < ApplicationController
  before_action :set_news, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show]
  #usuario normal
  before_action only: [:new, :edit] do
    authorize_request(["normal_user", "author", "admin"])
  end
  #usuario ejecutivo
  before_action only: [:create, :update] do
    authorize_request(["author", "admin"])
  end
  #usuario admin
  before_action only: [:destroy] do
    authorize_request(["admin"])
  end

  # GET /news or /news.json
  def index
    @pagy, @news = pagy(News.all)
    @consulta = params[:buscar]
    if @consulta.present?
      @news = News.search_full_text(@consulta)
    end
  end

  # GET /news/1 or /news/1.json
  def show
    @news = News.find(params[:id])
    @comments = Comment.where(news_id: @news.id)
    @comment = @news.comments.build
    @current_user_id = nil
    if current_user
    @current_user_id = current_user.id
    end
  end

  # GET /news/new
  def new
    @news = News.new
  end

  # GET /news/1/edit
  def edit
  end

  # POST /news or /news.json
  def create
    @news = News.new(news_params.merge(user_id: current_user.id))
    respond_to do |format|
      if @news.save
        format.html { redirect_to news_url(@news), notice: "News was successfully created." }
        format.json { render :show, status: :created, location: @news }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /news/1 or /news/1.json
  def update
    respond_to do |format|
      if @news.update(news_params.merge(user_id: current_user.id))
        format.html { redirect_to news_url(@news), notice: "News was successfully updated." }
        format.json { render :show, status: :ok, location: @news }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @news.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /news/1 or /news/1.json
  def destroy
    @news.destroy
    respond_to do |format|
      format.html { redirect_to news_index_url, notice: "News was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news
      @news = News.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def news_params
      params.require(:news).permit(:title, :content, :user_id)
    end
end
