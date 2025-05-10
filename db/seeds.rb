
puts "Creating Roles..."
roles = ['admin', 'member']
roles.each do |role_name|
  puts "Seeding role: #{role_name}"
  Role.find_or_create_by!(name: role_name)
end
puts "Roles created successfully!"

puts "Creating Permissions..."

permissions = [
  {
    role: Role.find_by(name: 'admin'),
    resource: 'user',
    actions: {
      'create': true,
      'read': true,
      'update': true,
      'delete': true,
      'self_update': true
    }
  },
  {
    role: Role.find_by(name: 'admin'),
    resource: 'club',
    actions: {
      'create': true,
      'read': true,
      'update': true,
      'delete': true
    }
  },
  {
    role: Role.find_by(name: 'admin'),
    resource: 'event',
    actions: {
      'create': true,
      'read': true,
      'update': true,
      'delete': true
    }
  },
  {
    role: Role.find_by(name: 'admin'),
    resource: 'announcement',
    actions: {
      'create': true,
      'read': true,
      'update': true,
      'delete': true
    }
  },
  {
    role: Role.find_by(name: 'admin'),
    resource: 'club_member',
    actions: {
      'create': true,
      'read': true,
      'update': true,
      'delete': true
    }
  },
  {
    role: Role.find_by(name: 'member'),
    resource: 'user',
    actions: {
      'create': false,
      'read': true,
      'update': false,
      'delete': false,
      'self_update': true
    }
  },
  {
    role: Role.find_by(name: 'member'),
    resource: 'club',
    actions: {
      'create': false,
      'read': true,
      'update': false,
      'delete': false
    }
  },
  {
    role: Role.find_by(name: 'member'),
    resource: 'event',
    actions: {
      'create': false,
      'read': true,
      'update': false,
      'delete': false
    }
  },
  {
    role: Role.find_by(name: 'member'),
    resource: 'announcement',
    actions: {
      'create': false,
      'read': true,
      'update': false,
      'delete': false
    }
  },
  {
    role: Role.find_by(name: 'member'),
    resource: 'club_member',
    actions: {
      'create': false,
      'read': true,
      'update': false,
      'delete': false
    }
  }
]
permissions.each do |permission|
  Permission.find_or_create_by!(permission)
end

# Quick access to change member type to 'manager'.
# Club.find(8).memberships.find(13).update(member_type: 'manager')

puts "Creating an admin user..."
User.create!(
  email: ENV['DEFAULT_USER_EMAIL'],
  name: 'Thinley Jimmy Dorji',
  password: ENV['DEFAULT_USER_PASSWORD'],
  password_confirmation: ENV['DEFAULT_USER_PASSWORD'],
  role_id: Role.find_by(name: 'admin').id
)
puts "User seed completed successfully!"
