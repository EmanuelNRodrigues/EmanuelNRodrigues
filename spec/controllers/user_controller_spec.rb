require 'rails_helper'

RSpec.describe(UserController, type: :controller) do
  describe 'index' do
    let(:users_count) { 3 }
    before do
      create_list(:user, users_count)
      get :index
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
    let(:create_request) { post :create, params: create_params }
    let(:create_params) { { full_name: 'Test', role: 'user', email: '1@b.c' } }

    context 'when saving correctly' do
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
      it 'is expected to respond with a status 422 unprocessable entity' do
        create_params[:email] = 'error'
        create_request
        expect(response.status).to eq 422
      end

      it 'is expected to respond with the invalid attributes and array of messages' do
        post :create, params: { full_name: '', role: 'admin', email: 'error@' }

        expect(JSON(response.body).symbolize_keys)
          .to eq(full_name: [Message::ERROR[:name_presence]],
                 email: [Message::ERROR[:email_format]])
      end
    end
  end

  describe 'show' do
    before { get :show, params: show_params }

    context 'when the pretended user exists' do
      let(:user) { create(:user) }
      let(:show_params) { { id: user.id } }

      it 'is expected to respond with a status 200 ok' do
        expect(response.status).to eq 200
      end

      it 'is expected to respond with the pretended user' do
        expect(JSON(response.body)).to include(user.attributes.except('created_at', 'updated_at'))
      end
    end

    context 'when the pretended user does not exist' do
      let(:show_params) { { id: 0 } }

      it 'is expected to respond with a status 404 not found' do
        expect(response.status).to eq 404
      end

      it 'is expected to respond with an empty body' do
        expect(response.body).to be_empty
      end
    end
  end

  describe 'update' do
    before { put :update, params: update_params }
    let(:user) { create(:user) }

    context 'when the pretended user exists and updates corretly' do
      let(:new_name) { 'New Test Name' }
      let(:update_params) { { id: user.id, full_name: new_name } }

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
      let(:update_params) { { id: user.id, full_name: '', email: 'error' } }

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
      let(:update_params) { { id: 0, full_name: 'New Name' } }

      it 'is expected to respond with a status 404 not found' do
        expect(response.status).to eq 404
      end

      it 'is expected to respond with an empty body' do
        expect(response.body).to be_empty
      end
    end
  end

  describe 'destroy' do
    let(:destroy_request) { delete :destroy, params: destroy_params }
    let(:user) { create(:user) }

    context 'when the pretended user exists' do
      let!(:destroy_params) { { id: user.id } }

      it 'is expected to respond with a status 200 ok' do
        destroy_request
        expect(response.status).to eq 200
      end

      it 'is expected to delete the pretended user' do
        expect { destroy_request }.to change(User, :count).by(-1)
      end
    end

    context 'when the pretended user does not exist' do
      let(:destroy_params) { { id: 0 } }

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
