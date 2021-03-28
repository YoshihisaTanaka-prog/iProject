# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.create(id: 1, name: '田中義久',email: 'nakanaka.tanaka4413@gmail.com', password: 'ToHi3118', subadmin: true, admin: true)
Admin.create(id: 0, name: 'TeLecture-bot',email: 'vbijkslaebrjvah@nviwbrhtibnsoihu', password: 'nvbuwrbaolhvralobalhreebvjaelijeveaiqjk', subadmin: true, admin: false)
AdminGroup.create(name: "全体", isSpecial: true, special_id: 0)
AdminGroup.create(name: "幹部", isSpecial: true, special_id: -1)
AdminGroup.create(name: "サポートセンター", isSpecial: true, special_id: 1)

Admin.all.each do |a|
    AdminGroup.all.each do |g|
        GroupAdmin.create(group_id: g.id, admin_id: a.id)
    end
end