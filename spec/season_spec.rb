require './lib/stat_tracker'
require './lib/season'

describe Season do
  let(:season) {Season.new({
                        :games => './data/games_spec.csv', 
                        :teams => './data/teams.csv', 
                        :game_teams => './data/game_teams_spec.csv'
                        })}
  
  describe '#initialize' do
    it 'exists' do
      expect(season).to be_a(Season)
    end

    it 'has attributes' do
      expect(season.games).to be_a(CSV::Table)
      expect(season.teams).to be_a(CSV::Table)
      expect(season.game_teams).to be_a(CSV::Table)
    end
  end

  describe '#winningest_coach(season)' do
    it 'returns the coach with the best win percentage for the season' do
      expect(season.winningest_coach("20152016")).to eq("Joel Quenneville")
      expect(season.winningest_coach("20122013")).to eq("Guy Boucher").or(eq("Adam Oates"))
    end
  end
end