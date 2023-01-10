require './spec/spec_helper'
require './lib/team_stats'
require './lib/stat_data'

describe TeamStats do
  let (:team_stats) {TeamStats.new({
    :games => './data/games_spec.csv',
    :teams => './data/teams.csv',
    :game_teams => './data/game_teams_spec.csv'
    })}

  describe '#initialize' do
    it 'exists' do
      expect(team_stats).to be_a(TeamStats)
    end
  end

  describe '#game_teams_data_by_team_id()' do
    it 'returns an array of game_teams data for a specific team' do
      expect(team_stats.game_teams_data_by_team_id('14')).to be_a(Array)
      expect(team_stats.game_teams_data_by_team_id('14').size).to eq(14)
    end
  end

  describe '#games_data_by_team_id()' do
    it 'returns an array of games data for a specific team' do
      expect(team_stats.games_data_by_team_id('14')).to be_a(Array)
      expect(team_stats.games_data_by_team_id('14').size).to eq(14)
    end
  end

  describe '#average_win_percentage()' do
    it "returns the average win percentage of a specific team by team ID" do
      expect(team_stats.average_win_percentage("14")).to eq 0.50
    end
  end

  describe '#goals_by_team_id()' do
    it "returns an array of goals for a specific team by team ID" do
      expect(team_stats.goals_by_team_id("14")).to eq([2, 1, 2, 3, 2, 0, 3, 2, 4, 2, 2, 3, 1, 2])
    end
  end

  describe '#most_goals_scored()' do
    it "returns the highest number of goals a team has scored in a single game" do
      expect(team_stats.most_goals_scored("14")).to eq 4
    end
  end

  describe '#fewest_goals_scored()' do
    it "returns the lowest number of goals a team has scored in a single game" do
      expect(team_stats.fewest_goals_scored("1")).to eq 1
    end
  end

  describe '#team_info()' do
    it 'returns a hash of team_id, franchise_id, team_name, abbreviation, link for a specific team' do
      expected_hash_1 = {
        "team_id" => "1", 
        "franchise_id" => "23", 
        "team_name" => "Atlanta United", 
        "abbreviation" => "ATL", 
        "link" => "/api/v1/teams/1"
      }

      expected_hash_2 = {
        "team_id" => "14", 
        "franchise_id" => "31", 
        "team_name" => "DC United", 
        "abbreviation" => "DC", 
        "link" => "/api/v1/teams/14"
      }

      expect(team_stats.team_info("1")).to eq(expected_hash_1)
      expect(team_stats.team_info("14")).to eq(expected_hash_2)
    end
  end

  describe '#results_by_season()' do
    it 'returns a hash of seasons(keys) and array of results(values) for a specific team' do
      expected_hash = {
        "20122013" => ['WIN', 'LOSS'],
        "20132014" => ['WIN'],
        "20142015" => ['LOSS'],
        "20152016" => ['LOSS', 'WIN'],
        "20172018" => ['WIN', 'LOSS', 'LOSS']
      }

      expect(team_stats.results_by_season("1")).to eq(expected_hash)
    end
  end

  describe '#season_team_win_percentage()' do
    it 'returns a hash of seasons(keys) and win percentages(values)' do
      expected_hash = {
        "20122013" => 0.5,
        "20132014" => 1.0,
        "20142015" => 0.0,
        "20152016" => 0.5,
        "20172018" => 0.33
      }

      expect(team_stats.season_team_win_percentage("1")).to eq(expected_hash)
    end
  end

  describe '#best_season()' do
    it 'returns the season with the highest win percentage for a team' do
      expect(team_stats.best_season("1")).to eq("20132014")
      expect(team_stats.best_season("14")).to eq("20122013")
    end
  end

  describe '#worst_season()' do
    it 'returns the season with the lowest win percentage for a team' do
      expect(team_stats.worst_season("3")).to eq("20142015")
      expect(team_stats.worst_season("29")).to eq("20142015")
    end
  end

  describe '#opponent_results()' do
    it 'returns a hash of team IDs(keys) and results(values) that a given team has played against' do
      expected_hash = {
        "15" => ["WIN", "WIN", "LOSS"],
        "14" => ["WIN", "WIN", "WIN"],
        "1" => ["LOSS"],
        "30" => ["TIE"]
      }
      expect(team_stats.opponent_results("3")).to eq(expected_hash)
    end
  end

  describe '#favorite_opponent' do
    it 'returns the name of the opponent that has the lowest win percentage against the given team' do
      expect(team_stats.favorite_opponent("3")).to eq("Atlanta United").or(eq("Orlando City SC"))
    end
  end

  describe '#rival' do
    it 'returns the name of the opponent that has the highest win percentage against the given team' do
      expect(team_stats.rival("3")).to eq("DC United")
    end
  end
end