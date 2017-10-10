require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "show users list" do
    let!(:users) {
      [
        FactoryGirl.create(:user),
        FactoryGirl.create(:user),
        FactoryGirl.create(:user)
      ]
    }

    before do
      get '/api/v1/users'
    end

    it 'have json content type' do
      expect(response.content_type).to eq("application/json")
    end

    it 'have status ok' do
      expect(response).to have_http_status(200)
    end

    it "show sorted users json" do
      serialization = ActiveModelSerializers::SerializableResource.new(
        Users::User.by_created,
        each_serializer: Users::UserSerializer
      ).to_json
      expect(response.body).to eq serialization
    end
  end

  describe "show user" do
    let!(:user) { FactoryGirl.create(:user) }

    before do
      get "/api/v1/users/#{user.id}"
    end

    it 'have json content type' do
      expect(response.content_type).to eq("application/json")
    end

    it 'have status ok' do
      expect(response).to have_http_status(200)
    end

    it "show user json" do
      serialization = ActiveModelSerializers::Adapter.create(Users::UserSerializer.new user).to_json
      expect(response.body).to eq serialization
    end
  end

  describe "create user" do
    let(:user_params) { FactoryGirl.attributes_for(:user) }

    context 'with valid parameters' do
      before do
        params = { user: user_params }
        post "/api/v1/users", params: params
      end

      it 'have json content type' do
        expect(response.content_type).to eq("application/json")
      end

      it 'have status created' do
        expect(response).to have_http_status(201)
      end

      it "show user json" do
        user = Users::User.find_by email: user_params[:email]
        serialization = ActiveModelSerializers::Adapter.create(Users::UserSerializer.new user).to_json
        expect(response.body).to eq serialization
      end

      it 'default role should be Blogger' do
        user = Users::User.find_by email: user_params[:email]
        expect(user.role).to eq 'Blogger'
      end
    end

    context 'with invalid parameters' do
      before do
        params = { user: {
          email: "123"
        } }
        post "/api/v1/users", params: params
      end

      it 'have json content type' do
        expect(response.content_type).to eq("application/json")
      end

      it 'have status unprocessable_entity' do
        expect(response).to have_http_status(422)
      end

      it "show errors" do
        expect(response.body).to include('errors')
      end
    end

    it 'creates new user' do
      params = { user: user_params }
      expect {
        post "/api/v1/users", params: params
      }.to change(Users::User, :count)
    end

    it 'not allow to specify role' do
      params = { user: user_params }
      params.merge({user: {role: 'Administrator'}})
      post "/api/v1/users", params: params
      user = Users::User.find_by email: user_params[:email]
      expect(user.role).to eq 'Blogger'
    end
  end

  describe "update user" do
    let(:user) { FactoryGirl.create(:user_with_auth) }
    let(:headers) { auth_header user }

    context 'without authorization' do
      it 'have unauthorized status' do
        put "/api/v1/users/#{user.id}"
        expect(response).to have_http_status(401)
      end
    end

    context 'with authorization' do
      context 'with valid parameters' do
        before do
          @params = { user: {
            nickname: 'new nickname',
            email: 'test@test.org'
          }}
          put "/api/v1/users/#{user.id}", params: @params, headers: headers
        end

        it 'have json content type' do
          expect(response.content_type).to eq("application/json")
        end

        it 'have status ok' do
          expect(response).to have_http_status(200)
        end

        it "show user json" do
          serialization = ActiveModelSerializers::Adapter.create(Users::UserSerializer.new user).as_json
          serialization.merge! @params[:user]
          expect(response.body).to eq serialization.to_json
        end
      end

      context 'with invalid parameters' do
        before do
          params = { user: {
            email: "123"
          } }
          put "/api/v1/users/#{user.id}", params: params, headers: headers
        end

        it 'have json content type' do
          expect(response.content_type).to eq("application/json")
        end

        it 'have status unprocessable_entity' do
          expect(response).to have_http_status(422)
        end

        it "show errors" do
          expect(response.body).to include('errors')
        end
      end
    end
  end

  describe "destroy user" do
    let!(:user) { FactoryGirl.create(:user_with_auth) }
    let(:headers) { auth_header user }

    context 'without authorization' do
      it 'have unauthorized status' do
        delete "/api/v1/users/#{user.id}"
        expect(response).to have_http_status(401)
      end
    end

    context 'with authorization' do
      before do
        delete "/api/v1/users/#{user.id}", headers: headers
      end

      it 'have status no_content' do
        expect(response).to have_http_status(204)
      end

      it "show nothing" do
        expect(response.body).to be_empty
      end
    end

    it 'deletes user' do
      expect {
        delete "/api/v1/users/#{user.id}", headers: headers
      }.to change(Users::User, :count).by(-1)
    end
  end

  describe "change_role of user" do
    let(:user) { FactoryGirl.create(:user_with_auth) }
    let(:headers) { auth_header user }

    context 'without authorization' do
      it 'have unauthorized status' do
        put "/api/v1/users/#{user.id}/change_role"
        expect(response).to have_http_status(401)
      end
    end

    context 'with authorization' do
      context 'with valid parameters' do
        before do
          @params = { user: {
            role: 'Administrator'
          }}
          put "/api/v1/users/#{user.id}/change_role", params: @params, headers: headers
        end

        it 'have json content type' do
          expect(response.content_type).to eq("application/json")
        end

        it 'have status ok' do
          expect(response).to have_http_status(200)
        end

        it "show user json" do
          serialization = ActiveModelSerializers::Adapter.create(Users::UserSerializer.new user).as_json
          serialization.merge! @params[:user]
          expect(response.body).to eq serialization.to_json
        end
      end

      context 'with invalid parameters' do
        before do
          params = { user: {
            role: 'Warrior'
          }}
          put "/api/v1/users/#{user.id}/change_role", params: params, headers: headers
        end

        it 'have json content type' do
          expect(response.content_type).to eq("application/json")
        end

        it 'have status unprocessable_entity' do
          expect(response).to have_http_status(422)
        end

        it "show errors" do
          expect(response.body).to include('errors')
        end
      end
    end
  end
end
