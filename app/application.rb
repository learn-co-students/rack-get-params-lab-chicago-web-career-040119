class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/)
      # Create a new route called /cart to show the items in your cart
      if @@cart.empty?
       resp.write "Your cart is empty"
      else
       @@cart.each do |item|
         resp.write "#{item}\n"
       end
     end
   elsif req.path.match(/add/)
     # Create a new route called /add that takes in a GET param with the key item
     item_to_add = req.params["item"]
     # can be solved like this, having an if/else loop inside the elif, using ewsp.write to print the output
     # if @@items.include? item_to_add
     #   @@cart << item_to_add
     #   resp.write "added #{item_to_add}"
     # else
     #   resp.write "We don't have that item!"
     # end

     # or using the helper method, look at the bottom!
     resp.write handle_add(item_to_add)
   else
      resp.write "Path Not Found"
    end

    resp.finish
  end


  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end

  def handle_add(item_to_add)
    # helper method for the add route that takes in a GET param with key["item"]
    if @@items.include? item_to_add
      @@cart << item_to_add
       return "added #{item_to_add}"
    else
     return "We don't have that item!"
    end
  end
end
