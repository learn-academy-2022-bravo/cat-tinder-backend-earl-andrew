require 'rails_helper'

RSpec.describe "Cats", type: :request do
  describe "GET /index" do
    it "gets a list of cats" do
      Cat.create(
        name: 'Felix',
        age: 2,
        enjoys: 'Walks in the park',
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      )

      get '/cats'

      cat = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(cat.length).to eq 1
    end
  end

  describe "POST /create" do
    it "creates a cat" do
      cat_params = {
        cat: {
          name: 'Buster',
          age: 4,
          enjoys: 'Meow Mix, and plenty of sunshine.',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
  
      post '/cats', params: cat_params 
      expect(response).to have_http_status(200) 
      cat = Cat.first
      expect(cat.name).to eq 'Buster'
    end
  end

  describe "PATCH /update" do
    it 'can update an existing cat' do
      cat_params = {
        cat: {
          name: 'Toast',
          age: 2,
          enjoys: 'allll the attention',
          image: 'http://www.catpics.com'
        }
      }
      post '/cats', params: cat_params
      cat = Cat.first

      update_cat_params = {
        cat: {
          name: 'Toast',
          age: 3,
          enjoys: 'allll the attention',
          image: 'http://www.catpics.com'
        }
      }
      patch "/cats/#{cat.id}", params: update_cat_params
      updated_cat = Cat.find(cat.id)
      expect(response).to have_http_status(200)
      expect(updated_cat.age).to eq(3)
    end
  end


  describe "DELETE /destroy" do
    it 'can delete an existing cat' do
      cat_params = {
        cat: {
          name: 'Toast',
          age: 2,
          enjoys: 'allll the attention',
          image: 'http://www.catpics.com'
        }
      }
      post '/cats', params: cat_params
      cat = Cat.first

      delete "/cats/#{cat.id}", params: cat_params
      expect(Cat.find_by(id: cat.id)).to be_nil
      expect(response).to have_http_status(204)
    end
  end

  describe "cat create requests validation" do
    it "doesn't create a cat without a name" do
      cat_params = {
        cat: {
          age: 2,
          enjoys: 'Walks in the park',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      post '/cats', params: cat_params
      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['name']).to include "can't be blank"
    end
    it "doesn't create a cat without an age" do
      cat_params = {
        cat: {
          name: "Toast",
          enjoys: 'Walks in the park',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      post '/cats', params: cat_params
      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['age']).to include "can't be blank"
    end
    it "doesn't create a cat without an enjoys" do
      cat_params = {
        cat: {
          name: "Toast",
          age: 4,
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
      post '/cats', params: cat_params
      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['enjoys']).to include "can't be blank"
    end
    it "doesn't create a cat without an image" do
      cat_params = {
        cat: {
          name: "Toast",
          age: 4,
          enjoys: "walks in the park"
        }
      }
      post '/cats', params: cat_params
      expect(response.status).to eq 422
      json = JSON.parse(response.body)
      expect(json['image']).to include "can't be blank"
    end
  end 






  describe "validate update" do
    it 'can update an existing cat and be validated' do
      cat_params = {
        cat: {
          name: 'Toast',
          age: 2,
          enjoys: 'allll the attention',
          image: 'http://www.catpics.com'
        }
      }
      post '/cats', params: cat_params
      cat = Cat.first

      update_cat_params = {
        cat: {
          name: "",
          age:nil,
          enjoys: '',
          image: ''
        }
      }
      patch "/cats/#{cat.id}", params: update_cat_params
      updated_cat = Cat.find(cat.id)
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json['name']).to include "can't be blank"
      expect(json['age']).to include "can't be blank"
      expect(json['enjoys']).to include "can't be blank"
      expect(json['image']).to include "can't be blank"
    end
  end




end

