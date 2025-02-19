require './lib/season_stats'

describe SeasonStats do
  let(:seasonstats) {SeasonStats.new({
                        :games => './data/games_spec.csv', 
                        :teams => './data/teams.csv', 
                        :game_teams => './data/game_teams_spec.csv'
                        })}
  
  describe '#initialize' do
    it 'exists' do
      expect(seasonstats).to be_a(SeasonStats)
    end

    it 'has attributes' do
      expect(seasonstats.games).to be_a(CSV::Table)
      expect(seasonstats.teams).to be_a(CSV::Table)
      expect(seasonstats.game_teams).to be_a(CSV::Table)
    end
  end

  describe '#winningest_coach(season)' do
    it 'returns the coach with the best win percentage for the season' do
      expect(seasonstats.winningest_coach("20152016")).to eq("Joel Quenneville")
      expect(seasonstats.winningest_coach("20122013")).to eq("Guy Boucher").or(eq("Adam Oates"))
    end
  end

  describe '#worst_coach(season)' do
    it 'returns the coach with the worst win' do
      expect(seasonstats.worst_coach("20162017")).to eq("Jared Bednar")
    end
  end

  describe '#team_shots_by_season(season)' do
    it 'returns a hash with the team_id(key) and total shots for the season(value)' do
      expected_hash = {
        '8' => 5,
        '1' => 12,
        '30' => 41,
        '16' => 41,
        '3' => 15,
        '15' => 16,
        '21' => 7,
        '14' => 6
      }

      expect(seasonstats.team_shots_by_season("20122013")).to eq(expected_hash)
    end
  end

  describe '#team_goals_by_season(season)' do
    it 'returns a hash with the team_id(key) and total goals for the season(value)' do
      expected_hash = {
        '8' => 2,
        '1' => 5,
        '30' => 10,
        '16' => 13,
        '3' => 1,
        '15' => 4,
        '21' => 1,
        '14' => 3
      }

      expect(seasonstats.team_goals_by_season("20122013")).to eq(expected_hash)
    end
  end

  describe '#team_shots_to_goals_ratio(season)' do
    it 'returns a hash with the team_id(key) and shots-to-goals ratio for the season(value)' do
      expected_hash = {
        '8' => 2.50,
        '1' => 2.40,
        '30' => 4.10,
        '16' => 3.1538461538461537,
        '3' => 15.00,
        '15' => 4.00,
        '21' => 7.00,
        '14' => 2.00
      }

      expect(seasonstats.team_shots_to_goals_ratio("20122013")).to eq(expected_hash)
    end
  end

  describe '#most_accurate_team' do
    it 'returns the team with the best ratio of shots to goals for the season' do
      expect(seasonstats.most_accurate_team("20122013")).to eq("DC United")
    end
  end

  describe '#least_accurate_team' do
    it 'returns the team with the highest ratio of shots to goals for the season' do
      expect(seasonstats.least_accurate_team("20122013")).to eq("Houston Dynamo")
    end
  end

  describe '#season_total_tackles(season)' do
    it 'returns a hash of total tackles by each team for the season' do
      expected_hash = {
        "15" => 84,
        "54" => 59,
        "14" => 33,
        "30" => 73,
        "52" => 137,
        "1" => 46,
        "21" => 49,
        "29" => 30
      }

      expect(seasonstats.season_total_tackles("20172018")).to eq(expected_hash)
    end
  end

  describe '#most_tackles(season)' do
    it 'returns the team name with the most tackles for the season' do
      expect(seasonstats.most_tackles("20122013")).to eq("Orlando City SC")
      expect(seasonstats.most_tackles("20172018")).to eq("Portland Thorns FC")
    end
  end

  describe '#fewest_tackles(season)' do
    it 'returns the team name with the fewest tackels for the season' do
      expect(seasonstats.fewest_tackles("20122013")).to eq("New York Red Bulls")
      expect(seasonstats.fewest_tackles("20172018")).to eq("Orlando Pride")
    end
  end

end