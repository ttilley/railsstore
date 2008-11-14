# always assign json data to :_json as a workaround.
ActionController::Base.param_parsers[Mime::JSON] = lambda do |body|
  if body.blank?
    {}
  else
    data = ActiveSupport::JSON.decode(body)
    data = {:_json => data}
    data.with_indifferent_access
  end
end
