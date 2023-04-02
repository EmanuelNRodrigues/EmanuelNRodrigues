require 'rails_helper'

RSpec.describe(ProjectsController, type: :request) do
  let(:projects_count) { 3 }
  let(:user) { create(:user, role:) }
  let(:project) { Project.first }

  before { create_list(:project, projects_count, user:) }

  describe 'index' do
    let(:index_request) { get user_projects_path(user.id) }

    context 'when user is admin' do
      let(:role) { 'admin' }
      it 'is expected to respond with a status 200 ok' do
        index_request
        expect(response.status).to be 200
      end

      it 'is expected to respond with the correct params' do
        index_request
        expect(JSON(response.body).first.keys).to match_array(%w[id name start_date end_date])
      end

      it 'is expected to retrieve all users projects' do
        create(:project, user: create(:user))
        index_request
        expect(JSON(response.body).count).to eq projects_count + 1
      end
    end

    context 'when user is customer' do
      let(:role) { 'customer' }
      it 'is expected to respond with a status 200 ok' do
        index_request
        expect(response.status).to be 200
      end

      it 'is expected to respond with the correct params' do
        index_request
        expect(JSON(response.body).first.keys).to match_array(%w[id name start_date end_date])
      end

      it 'is expected to retrieve only the current user projects' do
        create(:project, user: create(:user))
        index_request
        expect(JSON(response.body).count).to eq projects_count
      end
    end
  end

  describe 'create' do
    let(:role) { 'admin' }
    let(:create_request) { post user_projects_path(user.id), params: create_params }

    context 'when saves successfully' do
      let(:create_params) { attributes_for(:project) }

      it 'is expected to create a new project' do
        expect { create_request }.to change(Project, :count).by 1
      end

      it 'is expected to respond with a status 201 created' do
        create_request
        expect(response.status).to be 201
      end

      it 'is expected to respond with a message' do
        create_request
        expect(response.body).to eq Message::INFO[:project_create]
      end
    end

    context 'when errors occurs when creating a new project' do
      let(:create_params) { attributes_for(:project, name: nil) }

      it 'is expected to not create a new project' do
        expect { create_request }.to_not change(Project, :count)
      end

      it 'is expected to respond with a status 422 unprocessable entity' do
        create_request
        expect(response.status).to be 422
      end

      it 'is expected to respond with the error messages' do
        create_request
        expect(JSON(response.body)).to eq({ 'name' => [Message::ERROR[:name_presence]] })
      end
    end
  end

  describe 'update' do
    let(:role) { 'admin' }
    before { put user_project_path(user_id, project_id), params: update_params }

    context 'when the pretended project exists and updates corretly' do
      let(:project_id) { project.id }
      let(:user_id) { user.id }
      let(:update_params) { { name: new_name } }
      let(:new_name) { 'New Test Name' }

      it 'is expected to respond with a status 200 ok' do
        expect(response.status).to eq 200
      end

      it 'is expected to change the project correctly' do
        project.reload
        expect(project.name).to eq(new_name)
      end

      it 'is expected to respond with the updated user' do
        project.reload
        expect(project.attributes).to include(JSON(response.body).except('start_date', 'updated_at'))
      end
    end

    context 'when the pretended project existes but throws error when updating' do
      let(:project_id) { project.id }
      let(:user_id) { user.id }
      let(:update_params) { { name: '', start_date: nil } }

      it 'is expected to respond with a status 422 unprocessable entity' do
        expect(response.status).to eq 422
      end

      it 'is expeted to respond with the error messages' do
        expect(JSON(response.body).symbolize_keys)
          .to eq(name: [Message::ERROR[:name_presence]],
                 start_date: [Message::ERROR[:start_date_presence]])
      end
    end

    context 'when the pretended project does not exist' do
      let(:project_id) { 0 }
      let(:user_id) { user.id }
      let(:update_params) { { full_name: 'New Name' } }

      it 'is expected to respond with a status 404 not found' do
        expect(response.status).to eq 404
      end

      it 'is expected to respond with an empty body' do
        expect(response.body).to be_empty
      end
    end

    context 'when the pretended project is not associated with the given user' do
      let(:project_id) { project.id }
      let(:user_id) { 0 }
      let(:update_params) { { name: '', start_date: nil } }

      it 'is expected to respond with a status 404 not found' do
        expect(response.status).to eq 404
      end

      it 'is expected to respond with an empty body' do
        expect(response.body).to be_empty
      end
    end
  end
end
