# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Teams', type: :request do
  describe 'GET /teams/:id' do
    let!(:team) { Team.create(name: 'Team One') }

    context 'when the team exists' do
      it 'returns the team name' do
        get team_path(team), as: :json

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq(team.name)
      end
    end

    context 'when the team does not exist' do
      it 'returns a not found response with a message' do
        get team_path(id: 9999), as: :json

        expect(response).to have_http_status(404)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Record not found ')
      end
    end
  end

  describe 'GET /teams' do
    context 'when there are teams' do
      let!(:team1) { Team.create(name: 'Team One') }
      let!(:team2) { Team.create(name: 'Team Two') }

      it 'returns a list of teams' do
        get teams_path, as: :json

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(2)
        expect(json_response.map { |t| t['name'] }).to include(team1.name, team2.name)
      end
    end

    context 'when there are no teams' do
      it 'returns a not found response with a message' do
        Team.destroy_all

        get teams_path, as: :json

        expect(response).to have_http_status(200)
      end
    end
  end
  describe 'PATCH /teams/:id' do
    let!(:team) { Team.create(name: 'Old Team Name') }

    context 'when the team exists' do
      let(:valid_attributes) { { team: { name: 'Updated Team Name' } } }
      let(:invalid_attributes) { { team: { name: '' } } }

      context 'with valid attributes' do
        it 'updates the team and returns a success response' do
          patch team_path(team), params: valid_attributes, headers: { 'Content-Type' => 'application/json' }, as: :json
          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          expect(json_response['name']).to eq('Updated Team Name')
        end
      end

      context 'with invalid attributes' do
        it 'returns an unprocessable entity response with errors' do
          patch team_path(team), params: invalid_attributes, headers: { 'Content-Type' => 'application/json' },
                                 as: :json
          expect(response).to have_http_status(422)
          json_response = JSON.parse(response.body)
          expect(json_response['message']).to eq("Validation failed: Name can't be blank")
        end
      end
    end

    context 'when the team does not exist' do
      it 'returns a not found response with a message' do
        patch team_path(id: 9999), params: { team: { name: 'Any Name' } },
                                   headers: { 'Content-Type' => 'application/json' }, as: :json
        expect(response).to have_http_status(404)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Record not found ')
      end
    end
  end

  describe 'DELETE /teams/:id' do
    let!(:team) { Team.create(name: 'Team_rspec') }
    let!(:non_existent_team_id) { 9999 }

    context 'when the team exists' do
      it 'deletes the team and returns a success response' do
        expect do
          delete team_path(team), as: :json
        end.to change(Team, :count).by(-1)

        expect(response).to have_http_status(200)
      end
    end

    context 'when the team does not exist' do
      it 'returns a not found response with a message' do
        delete team_path(non_existent_team_id), as: :json
        expect(response).to have_http_status(404)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Record not found ')
      end
    end
  end

  describe 'POST /teams' do
    let(:valid_attributes) { { team: { name: 'New Team' } } }
    let(:invalid_attributes) { { team: { name: '' } } }

    context 'with valid attributes' do
      it 'creates a new team and returns a success response' do
        expect do
          post teams_path, params: valid_attributes, as: :json
        end.to change(Team, :count).by(1)

        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response['team']['name']).to eq(valid_attributes[:team][:name])
      end
    end

    context 'with invalid attributes' do
      it 'returns an unprocessable entity response with errors' do
        post teams_path, params: invalid_attributes, headers: { 'Content-Type' => 'application/json' }, as: :json

        expect(response).to have_http_status(422)
      end
    end
  end
end
