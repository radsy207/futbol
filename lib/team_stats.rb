require_relative './stat_data'

class TeamStats < StatData

  def initialize(locations)
    super(locations)
  end

  def game_teams_data_by_team_id(team_id)
    game_teams_data_by_team = @game_teams.select do |row|
      row if row[:team_id] == team_id
    end
    game_teams_data_by_team
  end

  def games_data_by_team_id(team_id)
    games_data_by_team = @games.select do |row|
      row if row[:away_team_id] == team_id || row[:home_team_id] == team_id
    end
    games_data_by_team
  end

  def average_win_percentage(team_id)
    game_teams_data_by_team = game_teams_data_by_team_id(team_id)
    team_wins = game_teams_data_by_team.count { |row| row[:result] == 'WIN'}
    (team_wins.to_f/ game_teams_data_by_team.count).round(2)
  end

  def goals_by_team_id(team_id)
    game_teams_data_by_team_id(team_id).map { |row| row[:goals].to_i}
  end

  def most_goals_scored(team_id)
    goals_by_team_id(team_id).sort.last
  end

  def fewest_goals_scored(team_id)
    goals_by_team_id(team_id).sort.first
  end

  def team_info(team_id)
    team_hash = {}
    @teams.each do |row|
      if row[:team_id] == team_id
        team_hash["team_id"] = row[:team_id]
        team_hash["franchise_id"] = row[:franchiseid]
        team_hash["team_name"] = row[:teamname]
        team_hash["abbreviation"] = row[:abbreviation]
        team_hash["link"] = row[:link]
      end
    end
    team_hash
  end

  def results_by_season(team_id)
    results_by_season = Hash.new{|k, v| k[v]= []}
    games_data_by_team_id(team_id).each do |row1|
      game_teams_data_by_team_id(team_id).each do |row2|
        results_by_season[row1[:season]] << row2[:result] if row1[:game_id] == row2[:game_id]
      end
    end
    results_by_season
  end

  def season_team_win_percentage(team_id)
    season_team_win_percent = {}
    results_by_season(team_id).each do |season, results|
      season_team_win_percent[season] = (results.count('WIN').to_f / results.size).round(2)
    end
    season_team_win_percent
  end

  def best_season(team_id)
    season_team_win_percentage(team_id).max_by{|k, v| v}.first
  end

  def worst_season(team_id)
    season_team_win_percentage(team_id).min_by{|k, v| v}.first
  end

  def opponent_results(team_id)
    team_game_ids = games_data_by_team_id(team_id).map {|row| row[:game_id]}

    results_by_team = Hash.new {|hash, key| hash[key] = []}
    @game_teams.each do |row|
      results_by_team[row[:team_id]] << row[:result] if team_game_ids.include?(row[:game_id]) && row[:team_id] != team_id
    end
    results_by_team
  end

  def opponent_win_percentage(team_id)
    win_percentage = {}
    opponent_results(team_id).each do |team_id, results|
      win_percentage[team_id] = results.count("WIN") / results.size.to_f
    end
    win_percentage
  end

  def favorite_opponent(team_id)
    favorite_opponent_team = opponent_win_percentage(team_id).min_by {|k, v| v}

    favorite_opponent = nil
    @teams.each do |row|
      favorite_opponent = row[:teamname] if row[:team_id] == favorite_opponent_team.first
    end
    favorite_opponent
  end

  def rival(team_id)
    rival_team = opponent_win_percentage(team_id).max_by{|k, v| v}

    rival= nil
    @teams.each do |row|
      rival = row[:teamname] if row[:team_id] == rival_team.first
    end
    rival
  end
end