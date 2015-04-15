Spree::AppConfiguration.class_eval do
  preference :matkahuolto_test_mode, :boolean, default: true
  preference :matkahuolto_username, :string, default: nil
  preference :matkahuolto_password, :string, default: nil
end
