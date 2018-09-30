5.times do
  g = Group.create(title: "#{Faker::Company.industry} team")
  12.times do
    User.create(username: "#{Faker::BojackHorseman.character.split(" ").map{|i| i.downcase}.join(".")}", password: "siobhan", password_confirmation: "siobhan", group_id: g.id)
  end
end

10.times do
  User.create(username: "#{Faker::Community.characters.split(" ").map{|i| i.downcase}.join(".")}", password: "siobhan", password_confirmation: "siobhan", group_id: Group.all.sample.id)
end
