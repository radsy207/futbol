require './lib/stat_tracker'

class Season < StatTracker

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

  def season_winningest_team(season_id)
    winning_team = season_record(season_id)
    winning_team.max_by {|k, v| v}[0]
  end

  def season_losing_team(season_id)
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
end