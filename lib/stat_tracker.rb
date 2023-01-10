require 'CSV'
require_relative './stat_data'
require_relative './team_stats'

class StatTracker < StatData

  attr_reader :games,
              :teams, 
              :game_teams
  
  def initialize(locations)
    super (locations)
    @team = TeamStats.new(locations)
  end

  def self.from_csv(locations)
    StatTracker.new(locations)
  end

  def team_info(team_id)
    @team.team_info(team_id)
  end

  def best_season(team_id)
    @team.best_season(team_id)
  end

  def worst_season(team_id)
    @team.worst_season(team_id)
  end

  def average_win_percentage(team_id)
    @team.average_win_percentage(team_id)
  end

  def most_goals_scored(team_id)
    @team.most_goals_scored(team_id)
  end

  def fewest_goals_scored(team_id)
    @team.fewest_goals_scored(team_id)
  end

  def favorite_opponent(team_id)
    @team.favorite_opponent(team_id)
  end

  def rival(team_id)
    @team.rival(team_id)
  end
   
end