require_relative './season_stats'
require_relative './stat_data'

class StatTracker < StatData
  attr_reader :games,
              :teams, 
              :game_teams
  
  def initialize(locations)
    super(locations)
    @season_stats = SeasonStats.new(locations)
  end

  def self.from_csv(locations)
    StatTracker.new(locations)
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
    (count.to_f / @games.size).round(2)
  end

  def percentage_visitor_wins
    count = @games.count do |row|
      row[:away_goals].to_i > row[:home_goals].to_i
    end
    (count.to_f / @games.size).round(2)
  end

  def percentage_ties
    count = @games.count do |row|
      row[:away_goals].to_i == row[:home_goals].to_i
    end
    (count.to_f / @games.size).round(2)
  end

  def count_of_teams
    @teams.length
  end

  def best_offense
    teams = []
    @games.each do |row|
      teams.push([row[:home_team_id], row[:home_goals]])
      teams.push([row[:away_team_id], row[:away_goals]])
    end

    hash = Hash.new {|hash, key| hash[key] = []}
    teams.each do |array|
      hash[array[0]] << array[1].to_i
    end

    hash.each do |k, v|
      if v.size > 1
        hash[k] = v.sum.to_f/v.size
      else
        hash[k] = v[0].to_f/1
      end
    end

    max_team = hash.max_by do |k, v|
      v
    end

    best_offense = nil
    @teams.each do |team|
      best_offense = team[:teamname] if team[:team_id] == max_team[0]
    end
    best_offense
  end

  def worst_offense
    teams = []
    @games.each do |row|
      teams.push([row[:home_team_id], row[:home_goals]])
      teams.push([row[:away_team_id], row[:away_goals]])
    end

    hash = Hash.new {|hash, key| hash[key] = []}
    teams.each do |array|
      hash[array[0]] << array[1].to_i
    end

    hash.each do |k, v|
      if v.size > 1
        hash[k] = v.sum.to_f/v.size
      else
        hash[k] = v[0].to_f/1
      end
    end

    min_team = hash.min_by do |k, v|
      v
    end

    worst_offense = nil
    @teams.each do |team|
      worst_offense = team[:teamname] if team[:team_id] == min_team[0]
    end
    worst_offense
  end
  
  
  def away_goals_by_team_id
    away_goals = Hash.new(0)
    @game_teams.each do |row|
      if row[:hoa] == "away"
        away_goals[row[:team_id]] += row[:goals].to_i
      end
      
    end
    away_goals 
  end

  def away_games_by_team_id
    away_games = Hash.new(0)
    @game_teams.each do |row|
      if row[:hoa] == "away"
        away_games[row[:team_id]] += 1
      end
      
    end
    away_games
  end

  def home_goals_by_team_id
    home_goals = Hash.new(0)
    @game_teams.each do |row|
      if row[:hoa] == "home"
        home_goals[row[:team_id]] += row[:goals].to_i
      end
      
    end
    home_goals 
  end

  def home_games_by_team_id
    home_games = Hash.new(0)
    @game_teams.each do |row|
      if row[:hoa] == "home"
        home_games[row[:team_id]] += 1
      end
      
    end
    home_games
  end

  def away_goal_avg_per_game
    hash = Hash.new(0)
    away_games_by_team_id.each do |teams1, games|
      away_goals_by_team_id.each do |teams2, goals|
        if teams1 == teams2
          hash[teams1] = (goals / games.to_f).round(2)
        end
      end
    end
    hash
  end

  def home_goal_avg_per_game
    hash = Hash.new(0)
    home_games_by_team_id.each do |teams1, games|
      home_goals_by_team_id.each do |teams2, goals|
        if teams1 == teams2
          hash[teams1] = (goals / games.to_f).round(2)
        end
      end
    end
    hash
  end

  def highest_scoring_visitor
    highest_visitor = away_goal_avg_per_game.max_by {|k, v| v}
    best_away_team = nil
    @teams.each do |team|
      if highest_visitor.first == team[:team_id]
        best_away_team = team[:teamname]
        
      end
    end
    best_away_team
  end

  def lowest_scoring_visitor
    highest_visitor = away_goal_avg_per_game.min_by {|k, v| v}
    best_away_team = nil
    @teams.each do |team|
      if highest_visitor.first == team[:team_id]
        best_away_team = team[:teamname]
        
      end
    end
    best_away_team
  end

  def highest_scoring_home_team
    highest_home_team = home_goal_avg_per_game.max_by {|k, v| v}
    best_home_team = nil
    @teams.each do |team|
      if highest_home_team.first == team[:team_id]
        best_home_team = team[:teamname]
        
      end
    end
    best_home_team
  end

  def lowest_scoring_home_team
    lowest_home_team = home_goal_avg_per_game.min_by {|k, v| v}
    best_home_team = nil
    @teams.each do |team|
      if lowest_home_team.first == team[:team_id]
        best_home_team = team[:teamname]
        
      end
    end
    best_home_team
  end


  def average_win_percentage(team)
    team_games = []
    won = []

    @game_teams.each do |game_team|
      if game_team[:team_id] == team
        team_games << game_team
      end
      team_games
    end

    team_games.each do |team_game|
      if team_game[:result] == 'WIN'
        won << team_game
      end
    end
    (won.count.to_f / team_games.count).round(2)
  end

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
  
  def game_ids_for_season(season)
    season_game_ids = []
    @games.each do |row|
      season_game_ids << row[:game_id] if row[:season] == season
    end
    season_game_ids
  end

  def season_total_tackles(season)
    season_game_ids = game_ids_for_season(season)
    season_tackles_by_team = Hash.new(0)
    @game_teams.each do |row|
      season_tackles_by_team[row[:team_id]] += row[:tackles].to_i if season_game_ids.include?(row[:game_id])
    end
    season_tackles_by_team
  end

  def most_tackles(season_id)
    @season_stats.most_tackles(season_id)
  end

  def fewest_tackles(season_id)
    @season_stats.fewest_tackles(season_id)
  end

  def winningest_coach(season_id)
    @season_stats.season_winningest_coach(season_id)
  end

  def worst_coach(season_id)
    @season_stats.season_losing_coach(season_id)
  end

  def most_accurate_team(season_id)
    @season_stats.most_accurate_team(season_id)
  end
  
  def least_accurate_team(season_id)
    @season_stats.least_accurate_team(season_id)
  end
end
