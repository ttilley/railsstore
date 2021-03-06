module Resourceful
  class Builder
    def make_resourceful_rails_store(options={})
      @controller.class_eval do
        include Resourceful::DojoPagination
        self.rails_store_pagination_options.merge!(options)
      end
            
      response_for :index do |format|
        format.html
        format.json do
          set_content_range_header
          render :json => current_objects.to_json
        end
      end
      
      response_for :show do |format|
        format.html
        format.json do
          render :json => current_object
        end
      end
      
      response_for :create do |format|
        format.html do
          redirect_to(current_object)
        end
        format.json do
          render :json => current_object, :status => :created, :location => current_object
        end
      end
      
      response_for :create_fails do |format|
        format.html do
          render :action => 'new'
        end
        format.json do
          render :json => current_object.errors, :status => :unprocessable_entity
        end
      end
      
      response_for :update do |format|
        format.html do
          redirect_to(current_object)
        end
        format.json do
          render :json => current_object
        end
      end
      
      response_for :update_fails do |format|
        format.html do
          redirect_to(current_object)
        end
        format.json do
          render :json => current_object.errors, :status => :unprocessable_entity
        end
      end
      
      response_for :destroy do |format|
        format.html do
          redirect_to(polymorphic_path(current_model.new))
        end
        format.json do
          head :ok
        end
      end
      
      response_for :destroy_fails do |format|
        format.html do
          redirect_to(current_object)
        end
        format.json do
          head :unprocessable_entity
        end
      end

    end
  end
  
  module DojoPagination
    def current_objects
      return @current_objects if defined?(@current_objects)
      
      options = self.class.rails_store_pagination_options.clone      
      options = rails_store_range_header(options)      
      options = rails_store_will_paginate(options)      
      options = rails_store_sorting(options)
            
      finder = options.delete(:finder) || :find
      if finder != :find then
        @current_objects = current_model.send(finder, options)
      else
        @current_objects = current_model.send(finder, :all, options)
      end
    end
  end
end
