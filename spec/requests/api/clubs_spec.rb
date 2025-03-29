# require 'rails_helper'
# require 'swagger_helper'
#
# RSpec.describe 'Clubs', type: :request do
#   include Warden::Test::Helpers
#
#   let(:params) do
#     {
#       club: {
#         name: 'ACM Student Chapter',
#         description: 'ACM Student Chapter at College of Science and Technology, RUB'
#       }
#     }
#   end
#
#   let(:role) { create(:role, :admin) }
#   let(:user) { create(:user, role: role) }
#
#   before do
#     Warden.test_mode!
#   end
#
#   after do
#     Warden.test_reset!
#   end
#
#   path '/clubs' do
#     post 'Create Club' do
#       tags 'Clubs'
#
#       consumes 'application/json'
#       parameter name: :params, in: :body, schema: {
#         type: :object,
#         properties: {
#           club: {
#             type: :object,
#             properties: {
#               name: { type: :string },
#               description: { type: :string }
#             },
#             required: %w[name description]
#           }
#         }
#       }
#
#       produces 'application/json'
#       context 'with valid parameters' do
#         response '200', 'Club Created' do
#           parameter name: :response, in: :body, schema: {
#             type: :object,
#             properties: {
#               id: { type: :integer },
#               name: { type: :string },
#               description: { type: :string }
#             }
#           }
#
#           it 'creates a club' do
#             login_as(user, scope: :user)
#             post clubs_path, params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
#
#             club = Club.first
#             expect(status).to eq(201)
#             expect(Club.count).to eq(1)
#             expect(club.memberships.count).to eq(1)
#             expect(club.name).to eq('ACM Student Chapter')
#             expect(club.description).to eq('ACM Student Chapter at College of Science and Technology, RUB')
#           end
#         end
#       end
#     end
#
#     get 'List Clubs' do
#       tags 'Clubs'
#
#       produces 'application/json'
#       context 'with valid parameters' do
#         response '200', 'Clubs Listed' do
#           it 'lists clubs' do
#             login_as(user, scope: :user)
#             5.times { create(:club, user: user) }
#             get clubs_path, headers: { 'ACCEPT' => 'application/json' }
#
#             expect(status).to eq(200)
#             expect(api_response.count).to eq(5)
#             expect(api_response.last['name']).to eq(Club.find(api_response.last['id']).name)
#           end
#         end
#       end
#     end
#   end
# end
