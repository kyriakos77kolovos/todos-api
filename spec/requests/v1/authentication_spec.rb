require 'swagger_helper'

RSpec.describe 'v1/authentication', type: :request do

    path '/auth/login' do
        post('Login') do
          tags 'Authentication'
          description 'Login to generate a token'
          consumes 'application/json'
          parameter name: :user, in: :body, schema: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string }
            },
            required: [ 'email', 'password']            
          }
    
          response(200, 'Successful login, returning an authentication token') do
            after do |example|
              example.metadata[:response][:content] = {
                'application/json' => {
                  example: JSON.parse(response.body, symbolize_names: true)
                }
              }
            end
            run_test!
          end
    
          response(400, 'Bad request') do
            run_test!
          end
    
          response(401, 'Unauthorized user') do
            run_test!
          end
        end
    end
    
    path '/signup' do
        post('Sign up') do
            tags 'Authentication'
            description 'Signup to generate a token'
            consumes 'application/json'
            parameter name: :user, in: :body, schema: {
            type: :object,
            properties: {
                name: { type: :string },
                email: { type: :string },
                password: { type: :string },
                password_confirmation: { type: :string}
            },
            required: [ 'name', 'email', 'password']
            }

            response(201, 'Successful sign-up, returning an authentication token') do
            after do |example|
                example.metadata[:response][:content] = {
                'application/json' => {
                    example: JSON.parse(response.body, symbolize_names: true)
                }
                }
            end
            run_test!
            end

            response(400, 'Bad request') do
            run_test!
            end

            response(422, 'Unprocessable content') do
            let(:'Authorization') { 'invalid_token' }
            run_test!
            end
        end
    end
end