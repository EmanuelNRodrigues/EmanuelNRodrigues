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

      it 'is expected to respond with a list of projects' do
        index_request
        expect(JSON(response.body).count).to eq projects_count
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

      it 'is expected to respond with a list of projects' do
        index_request
        expect(JSON(response.body).count).to eq projects_count
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



end
