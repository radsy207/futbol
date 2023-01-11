require_relative './league_stats'
require_relative './season_stats'
require_relative './stat_data'
require_relative './team_stats'

class StatTracker < StatData
  
  def initialize(locations)
    super(locations)
    @league_stats = LeagueStats.new(locations)
    @season_stats = SeasonStats.new(locations)
    @team_stat = TeamStats.new(locations)
  end

  def self.from_csv(locations)
    StatTracker.new(locations)
  end

# League_Stats

  def count_of_teams
    @teams.length
  end

  def best_offense
    @league_stats.best_offense
  end

  def worst_offense
    @league_stats.worst_offense
  end
  
  def highest_scoring_visitor
    @league_stats.highest_scoring_visitor
  end

  def highest_scoring_home_team
    @league_stats.highest_scoring_home_team
  end

  def lowest_scoring_visitor
    @league_stats.lowest_scoring_visitor
  end

  def lowest_scoring_home_team
    @league_stats.lowest_scoring_home_team
  end

# Season_Stats

  def winningest_coach(season_id)
    @season_stats.winningest_coach(season_id)
  end

  def worst_coach(season_id)
    @season_stats.worst_coach(season_id)
  end

  def most_accurate_team(season_id)
    @season_stats.most_accurate_team(season_id)
  end
  
  def least_accurate_team(season_id)
    @season_stats.least_accurate_team(season_id)
  end
  
  def most_tackles(season_id)
    @season_stats.most_tackles(season_id)
  end

  def fewest_tackles(season_id)
    @season_stats.fewest_tackles(season_id)
  end
  
  # Team_Stats
  
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