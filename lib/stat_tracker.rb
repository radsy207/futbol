require_relative './stat_data'
require_relative './team_stats'

class StatTracker < StatData
  
  def initialize(locations)
    super (locations)
    @team_stat = TeamStats.new(locations)
  end

  def self.from_csv(locations)
    StatTracker.new(locations)
  end

  def team_info(team_id)
    @team_stat.team_info(team_id)
  end

  def best_season(team_id)
    @team_stat.best_season(team_id)
  end

  def worst_season(team_id)
    @team_stat.worst_season(team_id)
  end

  def average_win_percentage(team_id)
    @team_stat.average_win_percentage(team_id)
  end

  def most_goals_scored(team_id)
    @team_stat.most_goals_scored(team_id)
  end

  def fewest_goals_scored(team_id)
    @team_stat.fewest_goals_scored(team_id)
  end

  def favorite_opponent(team_id)
    @team_stat.favorite_opponent(team_id)
  end

  def rival(team_id)
    @team_stat.rival(team_id)
  end
end