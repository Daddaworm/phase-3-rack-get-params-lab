require 'pry'

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


    #Create a new route called /cart to show the items in your cart.
    # --responds with empty cart message if the cart is empty
    # --responds with a cart list if there is something in there
    elsif req.path.match(/cart/)  
      if @@cart.length > 0 
          @@cart.each do |cart_item| 
            resp.write "#{cart_item}\n"
          end
      else
        resp.write "Your cart is empty"
      end


    # Create a new route called /add that takes in a GET param with the key item. This should check to see if that item is in @@items and add it to the cart if it is. Otherwise it should give an error
    # --Will add an item that is in the @@items list
    # --Will not add an item that is not in the @@items list
    elsif req.path.match(/add/)
      add_item = req.params["item"]
      # binding.pry
      if @@items.include?(add_item)
        @@cart << add_item
        resp.write "added #{add_item}"
      else 
        resp.write "We don't have that item"
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
