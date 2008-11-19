module RailsStore
  module WillPaginate
    private
    
    def rails_store_will_paginate(options={})
      if params[:page] &&
              (params[:per_page] != 'Infinity' && params[:page] != 0)
        
        options[:finder] = :paginate
        
        options[:page] = params[:page]
        options[:per_page] = params[:per_page]
        
        options.delete(:offset)
        options.delete(:limit)
      end
      
      return options
    end
  end
end
