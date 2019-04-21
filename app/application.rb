class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart =  #holds any items in our cart
  #the path lives in the HTTP request => we have to inspect env part of our #call function
  def call(env) #env is the variable with all info contained in the request
    resp = Rack::Response.new #Rack is parsing the info
    req = Rack::Request.new(env) #req is an instance, has a method #path that will return the path that was requested

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/) #search route that accepted a GET param with q key
      search_term = req.params["q"]
      resp.write handle_search(search_term) #used helper method
    elsif req.path.match(/cart/) #created a new route to show items in cart, filter so this only works for the /cart
      if @@cart.empty? #if no items in the cart
        resp.write "Your cart is empty"
      else
        @@cart.each do |item| #if there are items in the cart
          resp.write "#{item}\n"
      end
      end
    elsif req.path.match(/add/) #created a new route, takes in a GET params with the key item
      item_to_add = req.params["item"]
      if @@items.include? item_to_add #check to see if that item is in @@items
        @@cart << item_to_add
        resp.write "added #{item_to_add}"
      else resp.write "We don't have that item!"
      end
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
end
