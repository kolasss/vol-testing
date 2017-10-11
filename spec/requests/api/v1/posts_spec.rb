require 'rails_helper'

RSpec.describe "Api::V1::Posts", type: :request do
  describe "show users list" do
    let!(:posts) { FactoryGirl.create_list(:post, 30) }

    context 'without parameters' do
      before do
        get '/api/v1/posts'
      end

      it 'have json content type' do
        expect(response.content_type).to eq("application/json")
      end

      it 'have status ok' do
        expect(response).to have_http_status(200)
      end

      it "show sorted posts json" do
        serialization = ActiveModelSerializers::SerializableResource.new(
          Post.by_published.page(1),
          each_serializer: PostSerializer
        ).to_json
        expect(response.body).to eq serialization
      end

      it 'have header with total posts' do
        expect(response.headers['Items-Total']).to eq 30
      end

      it 'have header with total pages' do
        expect(response.headers['Pages-Total']).to eq 2
      end
    end

    context 'with parameters' do
      context 'page' do
        before do
          get '/api/v1/posts?page=2'
        end

        it "show sorted posts json" do
          serialization = ActiveModelSerializers::SerializableResource.new(
            Post.by_published.page(2),
            each_serializer: PostSerializer
          ).to_json
          expect(response.body).to eq serialization
        end

        it 'have header with total pages' do
          expect(response.headers['Pages-Total']).to eq 2
        end
      end

      context 'per_page' do
        before do
          get '/api/v1/posts?per_page=10'
        end

        it "show sorted posts json" do
          serialization = ActiveModelSerializers::SerializableResource.new(
            Post.by_published.page(1).per(10),
            each_serializer: PostSerializer
          ).to_json
          expect(response.body).to eq serialization
        end

        it 'have header with total pages' do
          expect(response.headers['Pages-Total']).to eq 3
        end
      end
    end
  end

  describe "show post" do
    let!(:post) { FactoryGirl.create(:post) }

    before do
      get "/api/v1/posts/#{post.id}"
    end

    it 'have json content type' do
      expect(response.content_type).to eq("application/json")
    end

    it 'have status ok' do
      expect(response).to have_http_status(200)
    end

    it "show post json" do
      serialization = ActiveModelSerializers::Adapter.create(PostSerializer.new post).to_json
      expect(response.body).to eq serialization
    end
  end

  describe "create post" do
    let(:post_params) { FactoryGirl.attributes_for(:post) }
    let(:user) {FactoryGirl.create(:user_with_auth)}
    let(:headers) { auth_header user }

    context 'without authorization' do
      it 'have unauthorized status' do
        post "/api/v1/posts", params: post_params
        expect(response).to have_http_status(401)
      end
    end

    context 'with authorization' do
      context 'with valid parameters' do
        before do
          params = { post: post_params }
          post "/api/v1/posts", params: params, headers: headers
        end

        it 'have json content type' do
          expect(response.content_type).to eq("application/json")
        end

        it 'have status created' do
          expect(response).to have_http_status(201)
        end

        it "show post json" do
          post = Post.find_by title: post_params[:title]
          serialization = ActiveModelSerializers::Adapter.create(PostSerializer.new post).to_json
          expect(response.body).to eq serialization
        end

        it 'posts author should be current_user' do
          post = Post.find_by title: post_params[:title]
          expect(post.author).to eq user
        end
      end

      context 'with invalid parameters' do
        before do
          params = { post: {
            title: "123"
          } }
          post "/api/v1/posts", params: params, headers: headers
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

      it 'creates new post' do
        params = { post: post_params }
        expect {
          post "/api/v1/posts", params: params, headers: headers
        }.to change(Post, :count)
      end

      it 'published_at set to Time.current if not specified' do
        time_current = Time.parse('2017-10-11 06:04:15 +0000')
        allow(Time).to receive(:current).and_return(time_current)
        post_params.delete(:published_at)
        params = { post: post_params }
        post "/api/v1/posts", params: params, headers: headers
        post = Post.find_by title: post_params[:title]
        expect(post.published_at).to eq time_current
      end

      it 'not allow to specify user' do
        user2 = FactoryGirl.create(:user)
        params = { post: post_params }
        params.merge({post: {author_id: user2.id}})
        post "/api/v1/posts", params: params, headers: headers
        post = Post.find_by title: post_params[:title]
        expect(post.author).to_not eq user2
      end
    end
  end

  describe "update post" do
    let(:post) { FactoryGirl.create(:post) }

    context 'without authorization' do
      it 'have unauthorized status' do
        put "/api/v1/posts/#{post.id}"
        expect(response).to have_http_status(401)
      end
    end

    context 'with authorization' do
      context 'as author' do
        let(:user) { FactoryGirl.create(:user_with_auth) }
        let(:headers) { auth_header user }
        let(:post) { FactoryGirl.create(:post, author: user) }

        context 'with valid parameters' do
          before do
            @params = { post: {
              title: 'new title',
              body: 'new body'
            }}
            put "/api/v1/posts/#{post.id}", params: @params, headers: headers
          end

          it 'have json content type' do
            expect(response.content_type).to eq("application/json")
          end

          it 'have status ok' do
            expect(response).to have_http_status(200)
          end

          it "show post json" do
            serialization = ActiveModelSerializers::Adapter.create(PostSerializer.new post).as_json
            serialization.merge! @params[:post]
            expect(response.body).to eq serialization.to_json
          end
        end

        context 'with invalid parameters' do
          before do
            params = { post: {
              title: ""
            } }
            put "/api/v1/posts/#{post.id}", params: params, headers: headers
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

      context 'as another blogger' do
        it 'is not allowed' do
          blogger = FactoryGirl.create(:user_with_auth, role: 'Blogger')
          headers = auth_header blogger
          params = { post: {
            title: "title"
          } }
          put "/api/v1/posts/#{post.id}", params: params, headers: headers
          expect(response).to have_http_status(403)
        end
      end

      context 'as admin' do
        it 'is allowed' do
          admin = FactoryGirl.create(:user_with_auth, role: 'Administrator')
          headers = auth_header admin
          params = { post: {
            title: "title"
          } }
          put "/api/v1/posts/#{post.id}", params: params, headers: headers
          expect(response).to have_http_status(200)
        end
      end
    end
  end

  describe "destroy post" do
    let!(:user) { FactoryGirl.create(:user_with_auth) }
    let(:headers) { auth_header user }
    let!(:post) { FactoryGirl.create(:post, author: user) }

    context 'without authorization' do
      it 'have unauthorized status' do
        delete "/api/v1/posts/#{post.id}"
        expect(response).to have_http_status(401)
      end
    end

    context 'with authorization' do
      context 'as author' do
        context 'response' do
          before do
            delete "/api/v1/posts/#{post.id}", headers: headers
          end

          it 'have status no_content' do
            expect(response).to have_http_status(204)
          end

          it "show nothing" do
            expect(response.body).to be_empty
          end
        end

        it 'deletes post' do
          expect {
            delete "/api/v1/posts/#{post.id}", headers: headers
          }.to change(Post, :count).by(-1)
        end
      end
    end

    context 'as another blogger' do
      it 'is not allowed' do
        blogger = FactoryGirl.create(:user_with_auth, role: 'Blogger')
        headers = auth_header blogger
        delete "/api/v1/posts/#{post.id}", headers: headers
        expect(response).to have_http_status(403)
      end
    end

    context 'as admin' do
      it 'is allowed' do
        admin = FactoryGirl.create(:user_with_auth, role: 'Administrator')
        headers = auth_header admin
        delete "/api/v1/posts/#{post.id}", headers: headers
        expect(response).to have_http_status(204)
      end
    end
  end
end
