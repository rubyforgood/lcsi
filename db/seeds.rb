password = TokenPhrase.generate
Account.create(username: "admin", password: password, admin: true, contest: Contest.create!)
puts "SAVE YOUR PASSWORD AND YOUR USERNAME :"
puts "admin:#{password}"

Contest.create
