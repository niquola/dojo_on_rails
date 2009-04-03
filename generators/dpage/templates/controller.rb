class <%= class_name %>Controller < ApplicationController
<% for action in actions -%>
  def <%= action %>
  end

<% end -%>
  def lorem
    render :text=>"<h3>Ajax Request on <%= class_name %></h3><p>params: #{params.to_json}</p>"
  end
end
