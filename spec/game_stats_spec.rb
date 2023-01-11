require './lib/game_stats'
require 'rspec'

RSpec.describe

describe GameStats do
  let(:game_stats) {GameStats.from_csv({
                        :games => './data/games_spec.csv', 
                        :teams => './data/teams.csv', 
                        :game_teams => './data/game_teams_spec.csv'
                        })}
  
  describe '#initialize' do
    it 'exists' do
      expect(game_stats).to be_a(GameStats)
    end
  end

  describe '#total_score' do
    it 'returns the total number of goals' do
      expect(game_stats.total_score).to be_a(Array)
      expect(game_stats.total_score.sum).to eq(261)
    end
  end

  describe '#highest_total_score' do
    it 'returns highest sum of the winning and losing teams scores' do
      expect(game_stats.highest_total_score).to eq(9)
    end
  end

  describe '#lowest_total_score' do
    it 'returns lowest sum of the winning and losing teams scores' do
      expect(game_stats.lowest_total_score).to eq(1)
    end
  end

  

  describe '#percentage_home_wins' do
    it 'returns percentage of wins at home' do
      expect(game_stats.percentage_home_wins).to eq(0.50)
    end
  end

  describe '#percentage_visitor_wins' do
    it 'returns percentage of visitor wins' do
      expect(game_stats.percentage_visitor_wins).to eq(0.37)
    end
  end

  describe '#percentage_ties' do
    it 'returns percentage of tied games' do
      expect(game_stats.percentage_ties).to eq(0.13)
    end
  end

  describe '#count_of_games_by_season' do
    it 'returns a hash of the number of games(values) per season(keys)' do
      expected_hash = {
        "20122013" => 10,
        "20132014" => 10,
        "20142015" => 10,
        "20152016" => 10,
        "20162017" => 10,
        "20172018" => 10
      }

      expect(game_stats.count_of_games_by_season).to eq(expected_hash)
    end
  end

  describe '#average_goals_per_game' do
    it 'returns the average number of goals per game' do
      expect(game_stats.average_goals_per_game).to eq(4.35)
    end
  end

  describe '#average_goals_by_season' do
    it 'returns a hash of the average goals(values) by season(keys)' do
      expected_hash = {
        "20122013" => 3.90,
        "20132014" => 4.60,
        "20142015" => 4.40,
        "20152016" => 4.70,
        "20162017" => 4.00,
        "20172018" => 4.50
      }
      
      expect(game_stats.average_goals_by_season).to eq(expected_hash)
    end
  end


end