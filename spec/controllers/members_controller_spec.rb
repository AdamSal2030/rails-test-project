require 'rails_helper'

RSpec.describe "Members", type: :request do
  describe "GET /members" do
    let!(:team1) { Team.create(name: "Team 1") }
    let!(:team2) { Team.create(name: "Team 2") }
    let!(:member1) { Member.create(first_name: "Adam", last_name: "Saleem", team: team1) }
    let!(:member2) { Member.create(first_name: "Eve", last_name: "Smith", team: team1) }
    let!(:member3) { Member.create(first_name: "John", last_name: "Doe", team: team2) }
    let!(:team) { Team.create(name: "Team 1") }
    let!(:member) { Member.create(first_name: "adam", last_name: "saleem", team: team) }

    it "returns a success response" do
      get members_path, as: :json
      expect(response).to be_successful
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    context "when no members are present" do
      before { Member.destroy_all }

      it "returns a not found response with a message" do
        get members_path, as: :json
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['message']).to eq('No members found')
      end
    end
  end

  describe "GET /members/:id" do
    let!(:team) { Team.create(name: "Team 1") }
    let!(:member) { Member.create(first_name: "Adam", last_name: "Saleem", team: team) }

    context "when the member exists" do
      it "returns the member's details" do
        get member_path(member), as: :json
        expect(response.content_type).to eq('application/json; charset=utf-8')

        json_response = JSON.parse(response.body)
        expect(json_response['first_name']).to eq(member.first_name)
        expect(json_response['last_name']).to eq(member.last_name)
      end
    end

    context "when the member does not exist" do
      it "returns a not found response with a message" do
        get member_path(id: 9999), as: :json
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['message']).to eq('No member found')
      end
    end
  end


  describe "PATCH /members/:id" do
    let!(:team) { Team.create(name: "Team 1") }
    let!(:member) { Member.create(first_name: "Adam", last_name: "Saleem", team: team) }

    let(:valid_attributes) { 
      { 
        member: { 
          first_name: "Updated Name", 
          last_name: "Updated LastName", 
          city: "Updated City", 
          state: "Updated State", 
          country: "Updated Country", 
          team_id: team.id 
        } 
      }
    }
    let(:invalid_attributes) { 
      { 
        member: { 
          first_name: "", 
          last_name: "", 
          city: "", 
          state: "", 
          country: "", 
          team_id: nil 
        } 
      }
    }
    let(:headers) { { "Content-Type" => "application/json" } }

    let(:expected_response) do
      {
        'first_name' => valid_attributes[:member][:first_name],
        'last_name' => valid_attributes[:member][:last_name],
        'city' => valid_attributes[:member][:city],
        'state' => valid_attributes[:member][:state],
        'country' => valid_attributes[:member][:country],
        'team_id' => valid_attributes[:member][:team_id]
      }
    end

    context "when the member exists" do
      context "with valid attributes" do
        it "updates the member and returns a success response" do
          patch member_path(member), params: valid_attributes, headers: headers, as: :json
          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          expect(json_response).to eq(expected_response)
        end
      end

      context "with invalid attributes" do
        it "returns an unprocessable entity response with errors" do
          patch member_path(member), params: invalid_attributes, headers: headers, as: :json
          expect(response).to have_http_status(422)
        end
      end
    end

    context "when the member does not exist" do
      it "returns a not found response with a message" do
        patch member_path(9999), params: valid_attributes.to_json, headers: headers, as: :json
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq('Member not found')
      end
    end
  end

  describe "DELETE /members/:id" do
    let!(:team) { Team.create(name: "Team 1") }
    let!(:member) { Member.create(first_name: "Adam", last_name: "Saleem", team: team) }

    context "when the member exists" do
      it "destroys the member and returns a success response" do
        delete member_path(member), as: :json
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('member destroyed')
        expect(Member.find_by(id: member.id)).to be_nil
      end
    end

    context "when the member does not exist" do
      it "returns a not found response with a message" do
        delete member_path(9999), as: :json
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Member not found')
      end
    end
  end

  describe "POST /teams/:team_id/members" do
    let!(:team) { Team.create(name: "Team 1") }

    context "with valid attributes" do
      let(:valid_attributes) do
        {
          member: {
            first_name: "John",
            last_name: "Doe",
            city: "New York",
            state: "NY",
            country: "USA"
          }
        }
      end

      it "creates a new member and returns a success response" do
        expect {
          post team_members_path(team_id: team.id), params: valid_attributes, headers: { "Content-Type" => "application/json" }, as: :json
        }.to change(Member, :count).by(1)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['first_name']).to eq(valid_attributes[:member][:first_name])
        expect(json_response['last_name']).to eq(valid_attributes[:member][:last_name])
        expect(json_response['city']).to eq(valid_attributes[:member][:city])
        expect(json_response['state']).to eq(valid_attributes[:member][:state])
        expect(json_response['country']).to eq(valid_attributes[:member][:country])
        expect(json_response['team_id']).to eq(team.id)
      end
    end

    context "with invalid attributes" do
      let(:invalid_attributes) do
        {
          member: {
            first_name: "",
            last_name: "",
            city: "",
            state: "",
            country: "",
            team_id: nil
          }
        }
      end

      it "does not create a new member and returns an error response" do
        expect {
          post team_members_path(team_id: team.id), params: invalid_attributes, headers: { "Content-Type" => "application/json" }, as: :json
        }.not_to change(Member, :count)

        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq("Failure to create")
        expect(json_response['errors']).to be_present
      end
    end
  end
end
