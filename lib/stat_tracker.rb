require_relative './stat_data'
require_relative './game_stats'

class StatTracker < StatData
  
  def initialize(locations)
    super(locations)
    @games_stats = GameStats.new(locations)
  end

  def self.from_csv(locations)
    StatTracker.new(locations)
  end

  def highest_total_score
    @games_stats.highest_total_score
  end

  def lowest_total_score
    @games_stats.lowest_total_score
  end

  def percentage_home_wins
    @games_stats.percentage_home_wins
  end

  def percentage_visitor_wins
    @games_stats.percentage_visitor_wins
  end

  def percentage_ties
    @games_stats.percentage_ties
  end

  def count_of_games_by_season
    @games_stats.count_of_games_by_season
  end

  def average_goals_per_game
    @games_stats.average_goals_per_game
  end

  def average_goals_by_season
    @games_stats.average_goals_by_season
  end
end

  
  