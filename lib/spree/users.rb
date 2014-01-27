module Spree::Users

  def init_users
    emails =  Spree::Order.where(:state => "complete" ).collect{|o| o.email}.uniq 
    emails += Spree::User.all.collect{|u| u.email}.uniq
    emails.delete_if {|u| u.blank? or u.index("example")} 
    @users = {}
    puts "Users #{emails.count}"
    emails.each do |mail|
      user_object = Spree::User.find_by_email mail
      next unless user_object
      user = passthrough( user_object , ["email", "encrypted_password", "password_salt" , "created_at"])
      
      if( user_object.bill_address != nil )
        add_address( user , user_object.bill_address )
      else
        order = Spree::Order.where( :email => mail).first
        add_address(user , order.bill_address ) if order
      end
      @users[user["email"]] = user
    end
  end

  def write_users
    write :users
  end
end
