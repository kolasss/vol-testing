class ReportDataAggregator
  def initialize(start_date, end_date)
    @start_date = start_date
    @end_date = end_date
  end

  def sorted_data
    get_users.map do |user|
      Row.new(
        user.nickname,
        user.email,
        count_posts(user),
        count_comments(user)
      )
    end.sort.reverse
  end

  private

    def get_users
      # Users::User.left_outer_joins(:posts, :comments)
      #   .where(
      #     '("posts"."published_at" BETWEEN :start_date AND :end_date) OR ("comments"."published_at" BETWEEN :start_date AND :end_date)',
      #     { start_date: @start_date, end_date: @end_date}
      #   ).distinct
      Users::User.all
    end

    def count_posts(user)
      Post.where(author_id: user.id, published_at: @start_date..@end_date).count
    end

    def count_comments(user)
      Comment.where(author_id: user.id, published_at: @start_date..@end_date).count
    end

  class Row
    include Comparable

    attr_reader :nickname, :email, :posts, :comments, :weight

    def initialize(nickname, email, posts, comments)
      @nickname = nickname
      @email = email
      @posts = posts
      @comments = comments
      @weight = posts + comments/10.0
    end

    def <=>(anOther)
      weight <=> anOther.weight
    end
  end
end
