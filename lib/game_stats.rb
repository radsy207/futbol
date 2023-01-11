require_relative './stat_data'

class GameStats < StatData
  
  def initialize(locations)
    super(locations)
    # @games = GameStats.new(locations)
  end

  def self.from_csv(locations)
    GameStats.new(locations)
  end
   
  def total_score
    total_score_array = []
    @games.each do |row|
       total_score_array << row[:away_goals].to_i + row[:home_goals].to_i
     end
    total_score_array
  end

  def highest_total_score
    total_score.max
  end

  def lowest_total_score
    total_score.min
  end

  def percentage_home_wins
    count = @games.count do |row|
      row[:home_goals].to_i > row[:away_goals].to_i
    end
    percentage_formula(count)
  end
  # require 'pry' ;binding.pry

  def percentage_visitor_wins
    count = @games.count do |row|
      row[:away_goals].to_i > row[:home_goals].to_i
    end
    percentage_formula(count)
  end

  def percentage_ties
    count = @games.count do |row|
      row[:away_goals].to_i == row[:home_goals].to_i
    end
    percentage_formula(count)
  end
  
  
  def count_of_games_by_season
    games_by_season = Hash.new(0)
    @games.each do |row|
      games_by_season[row[:season]] += 1
    end
    games_by_season
  end
  
  def average_goals_per_game
    percentage_formula(total_score.sum)
  end
  
  def average_goals_by_season
    goals_by_season = Hash.new(0)
    @games.each do |row|
      numerator = (row[:away_goals].to_i + row[:home_goals].to_i)
      goals_by_season[row[:season]] += numerator
    end
    
    games_by_season = count_of_games_by_season
    games_by_season.each do |key, value|
      denominator = value
      numerator = goals_by_season[key]
      goals_by_season[key] = (numerator/denominator.to_f).round(2)
    end
    goals_by_season
  end

  private

  def percentage_formula(count)
    (count.to_f / @games.size).round(2)
  end
end