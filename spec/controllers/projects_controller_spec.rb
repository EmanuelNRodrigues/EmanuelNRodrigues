require 'rails_helper'

RSpec.describe(ProjectsController, type: :request) do
  describe 'index' do
    let(:projects_count) { 3 }
    let(:index_request) { get user_projects_path(user.id) }
    before { create_list(:project, projects_count, user:) }

    context 'when user is admin' do
      let(:user) { create(:user, role: 'admin') }
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
      let(:user) { create(:user, role: 'customer') }
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
    let(:user) { create(:user) }
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
    xit 'we need tests'
  end
end
