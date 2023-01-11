require_relative './league_stats'
require_relative './season_stats'
require_relative './stat_data'

class StatTracker < StatData
  attr_reader :games,
              :teams, 
              :game_teams
  
  def initialize(locations)
    super(locations)
    @league_stats = LeagueStats.new(locations)
    @season_stats = SeasonStats.new(locations)
  end

  def self.from_csv(locations)
    StatTracker.new(locations)
  end

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

  def goals_by_team_id(team_id)
    goals = []
   
    @game_teams.each do |game|
      goals << game[:goals].to_i if game[:team_id] == team_id
    end
    goals
  end

  def most_goals_scored(team_id)
    goals_by_team_id(team_id).sort.last
  end

  def fewest_goals_scored(team_id)
    goals_by_team_id(team_id).sort.first
  end

  def team_info(team_id)
    team_hash = {}
    @teams.each do |team|
      if team[:team_id] == team_id
        team_hash["team_id"] = team[:team_id]
        team_hash["franchise_id"] = team[:franchiseid]
        team_hash["team_name"] = team[:teamname]
        team_hash["abbreviation"] = team[:abbreviation]
        team_hash["link"] = team[:link]
      end
    end
    team_hash
  end

  def count_of_games_by_season
    games_by_season = Hash.new(0)
    @games.each do |row|
      games_by_season[row[:season]] += 1
    end
    games_by_season
  end

  def best_season(team_id)
    team_id_results = Hash.new {|k, v| k[v]= ''}
    game_teams.each do |row|
      if row[:team_id] == team_id
        team_id_results[row[:game_id]] = row[:result]
      end
    end
    results_by_season = Hash.new{|k, v| k[v]= []}
    team_id_results.each do |game_id, result|
      games.each do |row|
        if row[:game_id] == game_id
          results_by_season[row[:season]] << result
        end
      end
    end
    win_loss_percent = Hash.new{|k, v| k[v]= ''}
    results_by_season.each do |season, results|
      wins = 0
      results.each do |result|
        if result == 'WIN'
          wins += 1
        end
      end
      win_loss_percent[season] = wins.to_f / results.count.to_f
    end
    win_loss_percent.max_by{|k, v| v}[0]
  end

  def worst_season(team_id)
    team_id_results = Hash.new {|k, v| k[v]= ''}
    game_teams.each do |row|
      if row[:team_id] == team_id
        team_id_results[row[:game_id]] = row[:result]
      end
    end
    results_by_season = Hash.new{|k, v| k[v]= []}
    team_id_results.each do |game_id, result|
      games.each do |row|
        if row[:game_id] == game_id
          results_by_season[row[:season]] << result
        end
      end
    end
    win_loss_percent = Hash.new{|k, v| k[v]= ''}
    results_by_season.each do |season, results|
      wins = 0
      results.each do |result|
        if result == 'WIN'
          wins += 1
        end
      end
      win_loss_percent[season] = wins.to_f / results.count.to_f
    end
    win_loss_percent.min_by{|k, v| v}[0]
  end

  def favorite_opponent(team_id)
    op_team = []
    @game_teams.each do |row|
      op_team << row[:game_id] if team_id == row[:team_id]  
    end

    hash = Hash.new {|hash, key| hash[key] = []}
    @game_teams.each do |row|
      hash[row[:team_id]] << row[:result] if op_team.include?(row[:game_id]) && row[:team_id] != team_id
    end
    
    win_percentage = {}
    hash.each do |team_id, results|
      win_percentage[team_id] = (results.count("WIN") / results.size.to_f) * 100
    end
    favorite_opponent_team = win_percentage.min_by{|k, v| v}

    favorite_opponent = nil
    @teams.each do |row|
    favorite_opponent = row[:teamname] if row[:team_id] == favorite_opponent_team.first
    end
    favorite_opponent
  end

  def rival(team_id)
    op_team = []
    @game_teams.each do |row|
      op_team << row[:game_id] if team_id == row[:team_id]  
    end

    hash = Hash.new {|hash, key| hash[key] = []}
    @game_teams.each do |row|
      hash[row[:team_id]] << row[:result] if op_team.include?(row[:game_id]) && row[:team_id] != team_id
    end
    
    win_percentage = {}
    hash.each do |team_id, results|
      win_percentage[team_id] = (results.count("WIN") / results.size.to_f) * 100
    end
    rival_team = win_percentage.max_by{|k, v| v}

    rival = nil
    @teams.each do |row|
    rival = row[:teamname] if row[:team_id] == rival_team.first
    end
    rival
  end

  def average_goals_per_game
    total_score_array = total_score
    (total_score_array.sum.to_f/@games.size).round(2)
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
  
  def most_tackles(season_id)
    @season_stats.most_tackles(season_id)
  end

  def fewest_tackles(season_id)
    @season_stats.fewest_tackles(season_id)
  end

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
end
