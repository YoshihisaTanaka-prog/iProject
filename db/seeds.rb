# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.create(name: '田中義久',email: 'nakanaka.tanaka4413@gmail.com', password: 'ToHi3118', subadmin: true, admin: true)
Admin.create(id: 0,name: 'TeLecture-bot',email: 'viberbn@nberjivan', password: 'iuhvyebdshi', subadmin: true, admin: true)
AdminGroup.create([{name: "全体"},{name: "幹部"}])
GroupAdmin.create([{group_id: 1, admin_id: 1},{group_id: 2, admin_id: 1}])