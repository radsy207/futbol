require_relative './stat_data'

class SeasonStats < StatData

  def initialize(locations)
    super(locations)
  end

  def game_ids_for_season(season_id)
    season_game_ids = []
    @games.each do |row|
      season_game_ids << row[:game_id] if row[:season] == season_id
    end
    season_game_ids
  end

  def season_team_wins(season_id)
    game_ids = game_ids_for_season(season_id)
    team_wins = Hash.new(0)
    @game_teams.each do |row|
      if game_ids.include?(row[:game_id]) && row[:result] == 'WIN'
        team_wins[row[:head_coach]] += 1
      end
    end
    team_wins
  end

  def season_winners_games_played(season_id)
    game_ids = game_ids_for_season(season_id)
    winner_games_played = Hash.new(0)
    @game_teams.each do |row|
      if game_ids.include?(row[:game_id])
        winner_games_played[row[:head_coach]] += 1
      end
    end
    winner_games_played
  end

  def season_record(season_id)
    seasons_hash = Hash.new(0)
    season_team_wins(season_id).each do |head_coach, wins|
      seasons_hash[head_coach] = (wins.to_f / season_winners_games_played(season_id)[head_coach])
    end
    seasons_hash
  end

  def winningest_coach(season_id)
    winning_team = season_record(season_id)
    winning_team.max_by {|k, v| v}[0]
  end

  def worst_coach(season_id)
    season_game_ids = game_ids_for_season(season_id)
  
    season_team_losses = Hash.new(0)
    season_losers_games_played = Hash.new(0)
    @game_teams.each do |row|
      if season_game_ids.include?(row[:game_id]) && (row[:result] == 'LOSS' || row[:result] == 'TIE')
        season_team_losses[row[:head_coach]] += 1
      end
      if season_game_ids.include?(row[:game_id])
        season_losers_games_played[row[:head_coach]] += 1
      end
    end

    season_record = Hash.new(0)
    season_team_losses.each do |head_coach, losses|
      season_record[head_coach] = (losses.to_f / season_losers_games_played[head_coach])
    end

    season_worst_team = season_record.max_by {|k, v| v}

    worst_coach = season_worst_team[0]
  end

  #i took 2 different design choices. one being abstracting the method into helper methods, passing around the season_id.
  #the other being abstracting the large method, only passing season_id once.
  #i'm using inheritance to use the functionality of stat tracker and i'm using encapsulation capture all seasons functionality in one class.
  def team_goals_by_season(season_id)
    season_game_ids = game_ids_for_season(season_id)

    team_goals_by_season = Hash.new(0)
    @game_teams.each do |row|
      if season_game_ids.include?(row[:game_id])
        team_goals_by_season[row[:team_id]] += row[:goals].to_i
      end
    end
    team_goals_by_season
  end

  def team_shots_by_season(season_id)
    season_game_ids = game_ids_for_season(season_id)

    team_shots_by_season = Hash.new(0)
    @game_teams.each do |row|
      if season_game_ids.include?(row[:game_id])
        team_shots_by_season[row[:team_id]] += row[:shots].to_i
      end
    end
    team_shots_by_season
  end

  def team_shots_to_goals_ratio(season_id)
    season_game_ids = game_ids_for_season(season_id)

    team_goals_by_season = team_goals_by_season(season_id)
    shots_to_goal_ratio_by_team = Hash.new(0)
    team_shots_by_season(season_id).each do |team_id, shots|
      shots_to_goal_ratio_by_team[team_id] = (shots.to_f / team_goals_by_season[team_id])
    end
    shots_to_goal_ratio_by_team
  end

  def most_accurate_team(season_id)
    season_game_ids = game_ids_for_season(season_id)
    team_shots_by_season(season_id)
    team_goals_by_season(season_id)
    shots_to_goal_ratios = team_shots_to_goals_ratio(season_id)
        
    best_shots_to_goal_ratio = shots_to_goal_ratios.min_by {|k, v| v}
    
    most_accurate_team = nil
    @teams.each do |row|
      most_accurate_team = row[:teamname] if row[:team_id] == best_shots_to_goal_ratio[0]
    end
    most_accurate_team
  end

  def least_accurate_team(season_id)
    season_game_ids = game_ids_for_season(season_id)
    team_shots_by_season(season_id)
    team_goals_by_season(season_id)
    shots_to_goal_ratios = team_shots_to_goals_ratio(season_id)
    
    highest_shots_to_goal_ratio = shots_to_goal_ratios.max_by {|k, v| v}

    least_accurate_team = nil
    @teams.each do |row|
      least_accurate_team = row[:teamname] if row[:team_id] == highest_shots_to_goal_ratio[0]
    end
    least_accurate_team
  end

  def season_total_tackles(season_id)
    season_game_ids = game_ids_for_season(season_id)
    season_tackles_by_team = Hash.new(0)
    @game_teams.each do |row|
      season_tackles_by_team[row[:team_id]] += row[:tackles].to_i if season_game_ids.include?(row[:game_id])
    end
    season_tackles_by_team
  end

  def most_tackles(season_id)
    season_tackles_by_team = season_total_tackles(season_id)
    
    most_tackles = season_tackles_by_team.max_by {|k, v| v}

    most_tackles_team = nil
    @teams.each do |row|
      most_tackles_team = row[:teamname] if row[:team_id] == most_tackles.first
    end
    most_tackles_team
  end

  def fewest_tackles(season_id)
    season_tackles_by_team = season_total_tackles(season_id)

    fewest_tackles = season_tackles_by_team.min_by {|k, v| v}

    fewest_tackles_team = nil
    @teams.each do |row|
      fewest_tackles_team = row[:teamname] if row[:team_id] == fewest_tackles.first
    end
    fewest_tackles_team
  end
end