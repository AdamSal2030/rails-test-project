# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Members', type: :request do
  describe 'GET /members' do
    context 'when there are members' do
      before do
        @team1 = FactoryBot.create(:team)
        @member1 = FactoryBot.create(:member, team: @team1)
        @member2 = FactoryBot.create(:member, team: @team1)
      end

      it 'When all member are found' do
        get members_path, as: :json
        expect(response).to be_successful

        members = JSON.parse(response.body)
        expect(members.size).to eq(2)

        expect(members).to include(
          hash_including('team_id' => @member1.team_id, 'id' => @member1.id, 'first_name' => @member1.first_name,
                         'last_name' => @member1.last_name),
          hash_including('team_id' => @member2.team_id, 'id' => @member2.id, 'first_name' => @member2.first_name,
                         'last_name' => @member2.last_name)
        )
      end
    end

    context 'when no members are present' do
      before { Member.destroy_all }

      it 'returns an empty array' do
        get members_path, as: :json
        expect(response).to be_successful
        response_body = JSON.parse(response.body)
        expect(response_body).to eq([])
      end
    end
  end

  describe 'GET /members/:id' do
    context 'when the member exists' do
      let!(:team) { FactoryBot.create(:team) }
      let!(:member) { FactoryBot.create(:member, team:) }
      let(:expected_response) do
        {
          first_name: member.first_name,
          last_name: member.last_name,
          state: member.state,
          country: member.country
        }.with_indifferent_access
      end

      it "returns the member's details" do
        get member_path(member), as: :json

        members = JSON.parse(response.body)
        expect(members).to eq(expected_response)
      end
    end

    context 'when the member does not exist' do
      it 'returns a not found response with a message' do
        get member_path(id: 9999), as: :json
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'PATCH /members/:id' do
    let!(:team) { Team.create(name: 'Team 1') }
    let!(:member) { Member.create(first_name: 'Adam', last_name: 'Saleem', team:) }

    let(:valid_attributes) do
      {
        member: {
          first_name: 'Updated Name',
          last_name: 'Updated LastName',
          city: 'Updated City',
          state: 'Updated State',
          country: 'Updated Country',
          team_id: team.id
        }
      }
    end
    let(:invalid_attributes) do
      {
        member: {
          first_name: '',
          last_name: '',
          city: '',
          state: '',
          country: '',
          team_id: nil
        }
      }
    end

    let(:expected_response) do
      {
        'first_name' => valid_attributes[:member][:first_name],
        'last_name' => valid_attributes[:member][:last_name],
        'city' => valid_attributes[:member][:city],
        'state' => valid_attributes[:member][:state],
        'country' => valid_attributes[:member][:country],
        'team_id' => valid_attributes[:member][:team_id]
      }.with_indifferent_access
    end

    context 'when the member exists' do
      context 'with valid attributes' do
        it 'updates the member and returns a success response' do
          patch member_path(member), params: valid_attributes, headers:, as: :json
          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          expect(json_response).to eq(expected_response)
        end
      end

      context 'with invalid attributes' do
        it 'returns an unprocessable entity response with errors' do
          patch member_path(member), params: invalid_attributes, headers:, as: :json
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'when the member does not exist' do
      it 'returns a not found response with a message' do
        patch member_path(9999), params: valid_attributes, headers:, as: :json
        expect(response).to have_http_status(404)
        JSON.parse(response.body)
      end
    end
  end

  describe 'DELETE /members/:id' do
    let!(:team) { Team.create(name: 'Team 1') }
    let!(:member) { Member.create(first_name: 'Adam', last_name: 'Saleem', team:) }

    context 'when the member exists' do
      it 'destroys the member and returns a success response' do
        delete member_path(member), as: :json
        expect(response).to have_http_status(204)
        expect(Member.find_by(id: member.id)).to be_nil
      end
    end

    context 'when the member does not exist' do
      it 'returns a not found response with a message' do
        delete member_path(9999), as: :json
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /teams/:team_id/members' do
    let!(:team) { Team.create(name: 'Team 1') }

    context 'with valid attributes' do
      let(:valid_attributes) do
        {
          member: {
            first_name: 'Adam',
            last_name: 'Saleem',
            city: 'NOP',
            state: 'Punjab',
            country: 'Pakistan'
          }
        }
      end

      it 'creates a new member and returns a success response' do
        expect do
          post team_members_path(team_id: team.id), params: valid_attributes,
                                                    headers: { 'Content-Type' => 'application/json' }, as: :json
        end.to change(Member, :count).by(1)

        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response['first_name']).to eq(valid_attributes[:member][:first_name])
        expect(json_response['last_name']).to eq(valid_attributes[:member][:last_name])
        expect(json_response['state']).to eq(valid_attributes[:member][:state])
        expect(json_response['country']).to eq(valid_attributes[:member][:country])
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) do
        {
          member: {
            first_name: '',
            last_name: '',
            city: '',
            state: '',
            country: '',
            team_id: nil
          }
        }
      end

      it 'does not create a new member and returns an error response' do
        expect do
          post team_members_path(team_id: team.id), params: invalid_attributes,
                                                    headers: { 'Content-Type' => 'application/json' }, as: :json
        end.not_to change(Member, :count)

        expect(response).to have_http_status(422)
        JSON.parse(response.body)
      end
    end
  end

  describe 'GET /teams/:team_id/members' do
    context 'when the team exists with members' do
      let!(:team) { FactoryBot.create(:team) }
      let!(:member) { FactoryBot.create(:member, team:) }

      it "returns the member's details" do
        get team_members_path(team_id: team.id), as: :json

        members = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(members.size).to eq(1)

        member_response = members.first
        expect(member_response['id']).to eq(member.id)
        expect(member_response['first_name']).to eq(member.first_name)
        expect(member_response['last_name']).to eq(member.last_name)
      end
    end

    context 'when no members exist for the team' do
      let!(:team) { FactoryBot.create(:team) }

      it 'returns an empty array' do
        get team_members_path(team_id: team.id), as: :json

        members = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(members).to be_empty
      end
    end
  end

  describe 'POST /projects/:project_id/members' do
    context 'when project exists and member does not exist in the project' do
      let!(:project) { FactoryBot.create(:project) }
      let!(:member) { FactoryBot.create(:member) }

      it 'adds the member to the project and returns a success response' do
        post project_members_path(project_id: project.id), params: { member_id: member.id }, as: :json

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Member succesfully added')

        expect(project.members).to include(member)
      end
    end

    context 'when project exists and member is already part of the project' do
      let!(:project) { FactoryBot.create(:project) }
      let!(:member) { FactoryBot.create(:member) }

      before do
        project.members << member
      end

      it 'returns an error response indicating the member is already part of the project' do
        post project_members_path(project_id: project.id), params: { member_id: member.id }, as: :json

        expect(response).to have_http_status(422)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Member is already part of the project')
      end
    end

    context 'when project does not exist' do
      let!(:member) { FactoryBot.create(:member) }

      it 'returns a not found response with a message' do
        post project_members_path(project_id: 9999), params: { member_id: member.id }, as: :json
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Record not found ')
      end
    end

    context 'when member does not exist' do
      let!(:project) { FactoryBot.create(:project) }

      it 'returns a not found response with a message' do
        post project_members_path(project_id: project.id), params: { member_id: 9999 }, as: :json
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Record not found ')
      end
    end
  end

  describe 'GET /projects/:project_id/members' do
    let!(:team) { Team.create(name: 'Development Team') }
    let(:project) { Project.create(name: 'Testing123') }
    let!(:member1) { project.members.create(first_name: 'Member One', last_name: 'Adam', team_id: team.id) }
    let!(:member2) { project.members.create(first_name: 'Member Two', last_name: 'Saleem', team_id: team.id) }

    context 'when the project exists and has members' do
      it 'returns a success response with the members of the project' do
        get "/projects/#{project.id}/members", as: :json
        expect(response).to have_http_status(200)

        json_response = JSON.parse(response.body)

        expect(json_response['project']).to include(
          'id' => project.id,
          'name' => project.name
        )

        expect(json_response['members']).to match_array(
          [
            a_hash_including('id' => member1.id, 'first_name' => 'Member One', 'last_name' => 'Adam'),
            a_hash_including('id' => member2.id, 'first_name' => 'Member Two', 'last_name' => 'Saleem')
          ]
        )
      end
    end
  end
end
