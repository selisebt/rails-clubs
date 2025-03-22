# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#

puts "Cleaning up existing data..."
ActiveRecord::Base.connection.execute("DELETE FROM memberships")
ActiveRecord::Base.connection.execute("DELETE FROM clubs")
ActiveRecord::Base.connection.execute("DELETE FROM users")
ActiveRecord::Base.connection.execute("DELETE FROM roles")
puts "Cleanup completed."

puts "Creating new roles..."
admin_role = Role.create!(
  name: 'admin'
)

member_role = Role.create!(
  name: 'member'
)

puts "Creating admin user..."
User.create!(
  email: 'td@selisegroup.com',
  name: 'Thinley Jimmy Dorji',
  password: 'password123',
  password_confirmation: 'password123',
  role_id: admin_role.id
)

puts "Seed completed successfully!"