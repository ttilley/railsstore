module RailsStore
  module RangeHeader
    private
        
    def rails_store_range_header(options={})
      if request.headers['HTTP_RANGE']
        match, pstart, pend = /items=([^-]*)-(.*)/.match(request.headers['HTTP_RANGE']).to_a
        
        pstart = 0 if pstart.blank?
        pend = pstart.to_i + 9 if pend.blank?
        
        options[:offset] = pstart.to_i unless pstart.to_i == 0
        unless pend == 'Infinity'
          options[:limit] = (pend.to_i - pstart.to_i).abs + 1
        end
      end
      
      return options
    end
    
    def set_content_range_header
      content_range = false
      
      if params[:onePage] == 'true'
        content_range = collection_object.length
      else
        content_range = model_object.count
      end
            
      headers['Content-Range'] = "/#{content_range}" if content_range
    end

  end
end