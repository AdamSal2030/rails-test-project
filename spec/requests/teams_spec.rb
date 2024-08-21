require 'swagger_helper'
require 'rails_helper'
describe 'Teams API' do

  path '/teams' do

    post 'Creates a team' do
      tags 'Teams'
      consumes 'application/json'
      parameter name: :team, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: [ 'name' ]
      }

      response '201', 'team created' do
        let(:team) { { name: 'koyt' } }
        let(:'Content-Type') { 'application/json' }
        let(:'Accept') { 'application/json' }
        run_test!
      end

      response '422', 'invalid request' do
        let(:team) { { name: '' } } 
        let(:'Content-Type') { 'application/json' }
        let(:'Accept') { 'application/json' }
        run_test!
      end
    end
  end

  path '/teams' do

    get 'Get all the teams' do
      tags 'Teams'
      produces 'application/json'

      response '200', 'teams retrieved' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string }
                 },
                 required: [ 'id', 'name' ]
               }

        before do
          create_list(:team, 3) 
        end
        run_test!
      end

      response '404', 'no teams found' do
        let(:team) { [] }
        before do
          Team.delete_all 
        end
        run_test!
      end
    end
  end

  path '/teams' do

    post 'Creates a team' do
      tags 'Teams'
      consumes 'application/json'
      parameter name: :team, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: [ 'name' ]
      }

      response '201', 'team created' do
        let(:team) { { name: 'koyt' } }
        let(:'Content-Type') { 'application/json' }
        let(:'Accept') { 'application/json' }
        run_test!
      end

      response '422', 'invalid request' do
        let(:team) { { name: '' } } 
        let(:'Content-Type') { 'application/json' }
        let(:'Accept') { 'application/json' }
        run_test!
      end
    end
  end

  path '/teams/{id}' do

    put 'Updates a team' do
      tags 'Teams'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'Team ID'
      parameter name: :team, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      response '200', 'team updated' do
        let(:id) { Team.create(name: 'Existing Team').id } 
        let(:team) { { name: 'Updated Team' } }

        run_test!
      end

      response '404', 'team not found' do
        let(:id) { 0 } # Non-existent team ID
        let(:team) { { name: 'Updated Team' } }

        run_test!
      end

      response '422', 'unprocessable entity' do
        let(:id) { Team.create(name: 'Existing Team').id } 
        let(:team) { { name: '' } } 

        run_test!
      end
    end
  end
  path '/teams/{id}' do
    get 'Show a specific team' do
      tags 'Teams'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'Team ID'
  
      response '200', 'Team found' do
        let(:id) { create(:team).id } 
  
        schema type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 name: { type: :string, example: 'Team A' }
               },
               required: [ 'id', 'name' ]
  
        run_test! 
      end
  
      response '404', 'Team not found' do
        let(:id) { 'invalid' } 
  
        run_test! 
      end
    end
  end
  path '/teams/{id}' do
    delete 'Delete a specific team' do
      tags 'Teams'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer
  
      response '204', 'Team deleted' do
        let(:id) { create(:team).id } 
  
        run_test! 
      end
  
      response '404', 'Team not found' do
        let(:id) { 'invalid' } 
  
        run_test! 
      end
    end
  end
end
