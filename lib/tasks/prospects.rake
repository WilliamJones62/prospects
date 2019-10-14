task :prospects => :environment do
  Prospect.get_orders
end
