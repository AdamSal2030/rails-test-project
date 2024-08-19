require 'rails_helper'

RSpec.describe "MemberProjects", type: :request do
  describe "POST /projects/:project_id/member_projects" do
    let!(:team) { Team.create(name: "Development Team") }
    let!(:project) { Project.create(name: "Test Project") }
    let!(:member) { Member.create(first_name: "John", last_name: "Doe", team_id: team.id) }
    let(:headers) { { "Content-Type" => "application/json" } }
    
    context "when the member is already part of the project" do
      before do
        project.members << member
      end

      it "returns an unprocessable entity response with a message" do
        post "/projects/#{project.id}/member_projects", params: { member_id: member.id }.to_json, headers: headers
        expect(response).to have_http_status(422)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq("Member is already part of the project")
      end
    end

    context "when the member is successfully added to the project" do
      it "returns a success response" do
        post "/projects/#{project.id}/member_projects", params: { member_id: member.id }.to_json, headers: headers
        expect(response).to have_http_status(406)
        project.reload
        expect(project.members).to include(member)
      end
    end
  end

  describe "GET /projects/:project_id/member_projects" do
    let!(:team) { Team.create(name: "Development Team") }
    let(:project) { Project.create(name: "Testing123") }
    let!(:member1) { project.members.create(first_name: "Member One", last_name: "Adam", team_id: team.id) }
    let!(:member2) { project.members.create(first_name: "Member Two", last_name: "Saleem", team_id: team.id) }

    context "when the project exists and has members" do
      it "returns a success response with the members of the project" do
        get "/projects/#{project.id}/member_projects", as: :json
        expect(response).to have_http_status(:success)
        
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
