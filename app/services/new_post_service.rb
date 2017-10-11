class NewPostService
  def initialize(post)
    @post = post
  end

  def create(user)
    set_defaults
    @post.author = user
    @post.save
  end

  private

    def set_defaults
      @post.published_at ||= Time.current
    end
end
