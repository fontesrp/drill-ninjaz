class LeaderboardController < ApplicationController

  BOARD_MAX_USERS = 10

  def index

    top_users = User.find_by_sql("SELECT
        sq1.user_id,
        SUM(sq1.max_pts) AS total_pts
      FROM (
        SELECT
          att.user_id,
          MAX(att.score * dgp.points) AS max_pts
        FROM
          attempts att
          INNER JOIN drill_groups dgp ON att.drill_group_id = dgp.id
        GROUP BY
          att.user_id,
          att.drill_group_id
      ) sq1
      GROUP BY
        sq1.user_id
      ORDER BY
        total_pts DESC
      LIMIT
        #{BOARD_MAX_USERS}")

    @leaders = [];

    top_users.each do |usr|
      @leaders << {
        user: User.find(usr.user_id),
        points: usr.total_pts,
        badges: badges(usr.total_pts)
      }
    end

    if user_signed_in?

      curr = User.find_by_sql("SELECT
          sq1.user_id,
          SUM(sq1.max_pts) AS total_pts
        FROM (
          SELECT
            att.user_id,
            MAX(att.score * dgp.points) AS max_pts
          FROM
            attempts att
            INNER JOIN drill_groups dgp ON att.drill_group_id = dgp.id
          WHERE
            att.user_id = #{current_user.id}
          GROUP BY
            att.user_id,
            att.drill_group_id
        ) sq1
        GROUP BY
          sq1.user_id")

      @current_user_points = curr[0]&.total_pts
      @current_user_badges = badges(@current_user_points)
    end
  end

  private

  def badges(score)
    if score.nil?
      0
    else
      (score / 62.5).to_i
    end
  end
end
