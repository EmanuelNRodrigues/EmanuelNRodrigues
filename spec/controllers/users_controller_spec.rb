require 'rails_helper'

RSpec.describe(UsersController, type: :request) do
  describe 'index' do
    let(:users_count) { 3 }
    before do
      create_list(:user, users_count)
      get users_path
    end

    it 'is expected to respond with a status 200 ok' do
      expect(response.status).to eq 200
    end

    it 'is expected to respond with a list of users' do
      expect(JSON(response.body).count).to eq users_count
    end

    it 'is expected to respond with the correct params' do
      expect(JSON(response.body).first.keys).to match_array(%w[id full_name email role])
    end
  end

  describe 'create' do
    let(:create_request) { post users_path, params: create_params }

    context 'when saving correctly' do
      let(:create_params) { { full_name: 'Test', role: 'user', email: '1@b.c' } }
      it 'is expected to respond with a status 201 created' do
        create_request
        expect(response.status).to eq 201
      end

      it 'is expected to respond with a success message' do
        create_request
        expect(response.body).to eq Message::INFO[:user_create]
      end

      it 'is expected to create a new user with the correct params' do
        expect { create_request }.to change(User, :count).by 1
        expect(User.last.attributes.symbolize_keys).to include(create_params)
      end
    end

    context 'when saving throws error' do
      let(:create_params) { { full_name: '', role: 'user', email: 'ERROR' } }
      it 'is expected to respond with a status 422 unprocessable entity' do
        create_request
        expect(response.status).to eq 422
      end

      it 'is expected to respond with the invalid attributes and array of messages' do
        create_request
        expect(JSON(response.body).symbolize_keys)
          .to eq(full_name: [Message::ERROR[:name_presence]],
                 email: [Message::ERROR[:email_format]])
      end
    end
  end

  describe 'show' do
    before { get user_path(user_id) }

    context 'when the pretended user exists' do
      let(:user) { create(:user) }
      let(:user_id) { user.id }

      it 'is expected to respond with a status 200 ok' do
        expect(response.status).to eq 200
      end

      it 'is expected to respond with the pretended user' do
        expect(JSON(response.body)).to include(user.attributes.except('created_at', 'updated_at'))
      end
    end

    context 'when the pretended user does not exist' do
      let(:user_id) { { id: 0 } }

      it 'is expected to respond with a status 404 not found' do
        expect(response.status).to eq 404
      end

      it 'is expected to respond with an empty body' do
        expect(response.body).to be_empty
      end
    end
  end

  describe 'update' do
    before { put user_path(user_id), params: update_params }
    let(:user) { create(:user) }

    context 'when the pretended user exists and updates corretly' do
      let(:user_id) { user.id }
      let(:update_params) { { full_name: new_name } }
      let(:new_name) { 'New Test Name' }

      it 'is expected to respond with a status 200 ok' do
        expect(response.status).to eq 200
      end

      it 'is expetect to change the user correctly' do
        user.reload
        expect(user.full_name).to eq(new_name)
      end

      it 'is expected to respond with the updated user' do
        user.reload
        expect(user.attributes).to include(JSON(response.body).except('updated_at'))
      end
    end

    context 'when the pretended user exists but throws error when updating' do
      let(:user_id) { user.id }
      let(:update_params) { { full_name: '', email: 'error' } }

      it 'is expected to respond with a status 422 unprocessable entity' do
        expect(response.status).to eq 422
      end

      it 'is expeted to respond with the error messages' do
        expect(JSON(response.body).symbolize_keys)
          .to eq(full_name: [Message::ERROR[:name_presence]],
                 email: [Message::ERROR[:email_format]])
      end
    end

    context 'when the pretended user does not exist' do
      let(:user_id) { 0 }
      let(:update_params) { { full_name: 'New Name' } }

      it 'is expected to respond with a status 404 not found' do
        expect(response.status).to eq 404
      end

      it 'is expected to respond with an empty body' do
        expect(response.body).to be_empty
      end
    end
  end

  describe 'destroy' do
    let(:destroy_request) { delete user_path(user_id) }
    let(:user) { create(:user) }

    context 'when the pretended user exists' do
      let!(:user_id) { user.id }

      it 'is expected to respond with a status 200 ok' do
        destroy_request
        expect(response.status).to eq 200
      end

      it 'is expected to delete the pretended user' do
        expect { destroy_request }.to change(User, :count).by(-1)
      end
    end

    context 'when the pretended user does not exist' do
      let!(:user_id) { 0 }

      it 'is expected to respond with a status 404 not found' do
        destroy_request
        expect(response.status).to eq 404
      end

      it 'is expected to respond with an empty body' do
        destroy_request
        expect(response.body).to be_empty
      end
    end
  end
end
