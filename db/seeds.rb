
puts "Creating Roles..."
roles = ['admin', 'member']
roles.each do |role_name|
  puts "Seeding role: #{role_name}"
  Role.find_or_create_by!(name: role_name)
end
puts "Roles created successfully!"

puts "Creating an admin user..."
User.create!(
  email: 'td@selisegroup.com',
  name: 'Thinley Jimmy Dorji',
  password: 'password123',
  password_confirmation: 'password123',
  role_id: Role.find_by(name: 'admin').id
)
puts "User seed completed successfully!"
