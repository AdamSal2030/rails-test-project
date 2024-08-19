require 'rails_helper'

RSpec.describe "Projects", type: :request do
  describe "POST /projects" do
    let(:valid_attributes) do
      {
        project: {
          name: "testing_rspec"
        }
      }
    end

    let(:headers) { { "Content-Type" => "application/json" } }

    context "creating the project with params" do
      it "creates a new project and returns a success response" do
        expect {
          post projects_path, params: valid_attributes, headers: headers, as: :json
        }.to change(Project, :count).by(1)

        expect(response).to have_http_status(200) 
      end
    end
  end

  describe "PATCH /projects/:id" do
    let!(:project) { Project.create(name: "Old Project Name") }
    
    let(:valid_attributes) do
      {
        project: {
          name: "Updated Project Name"
        }
      }
    end


    let(:headers) { { "Content-Type" => "application/json" } }

    context "when the project exists" do
      context "with valid attributes" do
        it "updates the project and returns a success response" do
          patch project_path(project), params: valid_attributes, headers: headers, as: :json
          
          expect(response).to have_http_status(:ok) 
          json_response = JSON.parse(response.body)
          expect(json_response['name']).to eq(valid_attributes[:project][:name])
        end
      end
    end

    context "when the project does not exist" do
      it "returns a not found response with a message" do
        patch project_path(9999), params: valid_attributes.to_json, headers: headers, as: :json
          
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response['message']).to eq("No project with this id exist")
      end
    end
  end

  describe "GET /projects" do
    context "when there are projects" do
      let!(:project1) { Project.create(name: "Project 1") }
      let!(:project2) { Project.create(name: "Project 2") }

      it "returns a success response with the list of projects" do
        get projects_path, as: :json
        
        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(2)
        expect(json_response.map { |p| p['name'] }).to include(project1.name, project2.name)
      end
    end

    context "when there are no projects" do
      before { Project.destroy_all }

      it "returns a not found response with a message" do
        get projects_path, as: :json
        
        expect(response).to have_http_status(200) 
      end
    end
  end

  describe "GET /projects/:id" do
    let!(:project) { Project.create(name: "Project 1") }

    context "when the project exists" do
      it "returns the project details with a success response" do
        get project_path(project), as: :json

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        json_response = JSON.parse(response.body)
        expect(json_response['name']).to eq(project.name)
      end
    end

    context "when the project does not exist" do
      it "returns a not found response with a message" do
        get project_path(id: 9999), as: :json

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        json_response = JSON.parse(response.body)
        expect(json_response).to be_a(Hash)
        expect(json_response['message']).to eq('Project not found')
      end
    end
  end

  describe "DELETE /projects/:id" do
    let!(:project) { Project.create(name: "testing_rspec") }

    context "when the project exists" do
      it "destroys the project and returns a success response" do
        expect {
          delete project_path(project), as: :json
        }.to change(Project, :count).by(-1) 

        expect(response).to have_http_status(200)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context "when the project does not exist" do
      it "returns a not found response with a message" do
        delete project_path(id: 9999), as: :json

        expect(response).to have_http_status(200) 
        expect(response.content_type).to eq('application/json; charset=utf-8')

        json_response = JSON.parse(response.body)
        expect(json_response).to be_a(Hash)
        expect(json_response['message']).to eq('Project not found')
      end
    end
  end




end
