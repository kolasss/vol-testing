require 'rails_helper'

RSpec.describe "Api::V1::Auth", type: :request do
  describe "login user" do
    let!(:user) { FactoryGirl.create(:user) }

    context 'with valid parameters' do
      before do
        params = { user: {
          email: user.email,
          password: user.password
        }}
        post "/api/v1/auth", params: params
      end

      it 'have json content type' do
        expect(response.content_type).to eq("application/json")
      end

      it 'have status ok' do
        expect(response).to have_http_status(200)
      end

      it "show encoded JWT token with auth_id of user" do
        decoded_token = UserAuthentication::AuthToken.decode response.body
        expect(decoded_token['auth_id']).to eq user.authentications.last.id
      end
    end

    context 'with invalid parameters' do
      before do
        params = { user: {
          email: user.email,
          password: 'wrong'
        }}
        post "/api/v1/auth", params: params
      end

      it 'have json content type' do
        expect(response.content_type).to eq("application/json")
      end

      it 'have status unauthorized' do
        expect(response).to have_http_status(401)
      end

      it "show errors" do
        expect(response.body).to include('errors')
      end
    end
  end

  describe "destroy user token" do
    let!(:user) { FactoryGirl.create(:user_with_auth) }
    let!(:auth) { FactoryGirl.create(:authentication, user: user) }
    let(:headers) { auth_header_with_auth auth }

    context 'without authorization' do
      it 'have unauthorized status' do
        delete "/api/v1/auth"
        expect(response).to have_http_status(401)
      end
    end

    context 'with authorization' do
      context 'with valid parameters' do
        before do
          params = { token: 'current' }
          delete "/api/v1/auth", params: params, headers: headers
        end

        it 'have status no_content' do
          expect(response).to have_http_status(204)
        end

        it "show nothing" do
          expect(response.body).to be_empty
        end
      end

      context 'token: current' do
        it 'deletes current token' do
          params = { token: 'current' }
          expect {
            delete "/api/v1/auth", params: params, headers: headers
          }.to change(Users::Authentication, :count).by(-1)
          expect {Users::Authentication.find auth.id }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'token: other' do
        it 'deletes other tokens' do
          expect(user.authentications.size).to eq 2
          params = { token: 'other' }
          expect {
            delete "/api/v1/auth", params: params, headers: headers
          }.to change(Users::Authentication, :count).by(-1)
          expect(Users::Authentication.find auth.id).to eq auth
          expect(user.authentications.size).to eq 1
        end
      end

      context 'with invalid parameters' do
        before do
          params = { token: 'all' }
          delete "/api/v1/auth", params: params, headers: headers
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
