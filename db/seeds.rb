# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Admin.create(id: 1, name: '田中義久',email: ENV['MY_ADDRESS'], password: ENV['MY_PW'], subadmin: true, admin: true)
# Admin.create(id: 0, name: 'TeLecture-bot',email: ENV['BOT_ADDRESS'], password: ENV['BOT_PW'], subadmin: true, admin: false)
# AdminGroup.create(name: "全体", isSpecial: true, special_id: 0)
# AdminGroup.create(name: "幹部", isSpecial: true, special_id: -1)
# AdminGroup.create(name: "サポートセンター", isSpecial: true, special_id: 1)

# Admin.all.each do |a|
#     AdminGroup.all.each do |g|
#         GroupAdmin.create(group_id: g.id, admin_id: a.id)
#     end
# end

User.create(user_id: "WkZOFnaNDtb9H6Aa", role: "teacher", domain: "s.kyushu-u.ac.jp", parameter_id: "U9xvD37sOc4fQmwX")
User.create(user_id: "Wc5lpw2YMRIxuDpM", role: "teacher", domain: "s.kyushu-u.ac.jp", parameter_id: "uOajLLUuhDXHj7cQ")
User.create(user_id: "0qqx5ugm42UFFrOV", role: "teacher", domain: "gmail.com", parameter_id: "kbL1ZQQVhmdFtrWk")
User.create(user_id: "eugakA6u1ZXUfuzR", role: "teacher", domain: "gmail.com", parameter_id: "yI8LbW6NKVKWP5kF")
User.create(user_id: "eKwToooiFnyI8BHC", role: "student", parameter_id: "MjlPd28fNycJAsxZ")
User.create(user_id: "UfDI1Re0cx4P1Ikm", role: "student", parameter_id: "2rKrwAPBBnicKtBS")
User.create(user_id: "Fqcwf7C9nqwPYvNN", role: "student", parameter_id: "D9vY7nxhsSbSxhmW")