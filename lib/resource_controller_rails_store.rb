module ResourceController
  module ActionControllerExtension    
    def resource_controller_rails_store(options={})
      self.class_eval do
        include ResourceController::DojoPagination
        
        self.rails_store_pagination_options.merge!(options)
        
        index.wants.json do
          set_content_range_header
          render :json => collection.to_json
        end
        
        show.wants.json do
          render :json => object.to_json
        end
        
        create.wants.json do
          render :json => object
        end
        
        create.flash nil
        
        create.failure.wants.json do
          render :json => object.errors, :status => :unprocessable_entity
        end
        
        update.wants.json do
          render :json => object
        end
        
        update.flash nil
        
        update.failure.wants.json do
          render :json => object.errors, :status => :unprocessable_entity
        end
        
        destroy.wants.json do
          head :ok
        end
        
        destroy.flash nil
        
        destroy.failure.wants.json do
          head :unprocessable_entity
        end
        
      end
    end
  end

  module DojoPagination
    def collection
      return @collection if defined?(@collection)
      
      options = self.class.rails_store_pagination_options
      RAILS_DEFAULT_LOGGER.debug(options.to_json) if RAILS_DEFAULT_LOGGER.debug?
      
      options = rails_store_range_header(options)
      RAILS_DEFAULT_LOGGER.debug(options.to_json) if RAILS_DEFAULT_LOGGER.debug?
      
      options = rails_store_will_paginate(options)
      RAILS_DEFAULT_LOGGER.debug(options.to_json) if RAILS_DEFAULT_LOGGER.debug?
      
      options = rails_store_sorting(options)
      RAILS_DEFAULT_LOGGER.debug(options.to_json) if RAILS_DEFAULT_LOGGER.debug?
      
      finder = options.delete(:finder) || :find
      if finder != :find then
        @collection = end_of_association_chain.send(finder, options)
      else
        @collection = end_of_association_chain.send(finder, :all, options)
      end
    end

  end
end
