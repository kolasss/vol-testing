class Api::V1::PostsController < Api::V1::ApplicationController
  before_action :require_login, only: [:create, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.by_published.page params[:page]
    @posts = @posts.per(params[:per_page]) if params[:per_page]
    set_headers
    render json: @posts
  end

  # GET /posts/1
  def show
    set_post
    render json: @post
  end

  # POST /posts
  def create
    authorize Post
    @post = Post.new(post_params)

    if NewPostService.new(@post).create(current_user)
      render json: @post, status: :created
    else
      render_post_errors
    end
  end

  # PATCH/PUT /posts/1
  def update
    set_and_authorize_post
    if @post.update(post_params)
      render json: @post
    else
      render_post_errors
    end
  end

  # DELETE /posts/1
  def destroy
    set_and_authorize_post
    if @post.destroy
      head :no_content
    else
      render_post_errors
    end
  end

  private

    def set_post
      @post = Post.find(params[:id])
    end

    def set_and_authorize_post
      set_post
      authorize @post
    end

    def post_params
      params.require(:post).permit(
        :title,
        :body,
        :published_at
      )
    end

    def render_post_errors
      render json: {errors: @post.errors}, status: :unprocessable_entity
    end

    def set_headers
      total_pages = @posts.total_pages
      total_posts = Post.count
      response.headers['Pages-Total'] = total_pages
      response.headers['Items-Total'] = total_posts
    end
end
