# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'faker'

# db/seeds.rb


UserTrainingPlan.destroy_all
PurchaseHistory.destroy_all
TrainingPlan.destroy_all
User.destroy_all
puts "Base de données supprimée"

permanent_user = User.create!(
  email: 'user@test.fr',
  firstname: 'UserExemple',
  password: 'aaaaaa',
  is_coach: false
)

permanent_coach = User.create!(
  email: 'coach@test.fr',
  firstname: 'CoachExemple',
  password: 'aaaaaa',
  is_coach: true
)

puts "Coach@test.fr, 'aaaaaa' créé."

coaches = 5.times.map do
  User.create!(
    email: Faker::Internet.email,
    password: 'azerty',
    is_coach: true,
    firstname: Faker::Name.first_name,
    description: Faker::Lorem.paragraph(sentence_count: 2),
    image_url: Faker::Avatar.image,
  )
end

puts 'Coachs créés.'

coaches.each do |coach|
  3.times do
    TrainingPlan.create!(
      name: Faker::Sport.sport,
      description: Faker::Lorem.paragraph(sentence_count: 5),
      price: Faker::Commerce.price(range: 10..100),
      coach: coach,
      url: Faker::Internet.url
    )
  end
end
puts "Programmes d'entrainements créés."

clients = 10.times.map do
  User.create!(
    email: Faker::Internet.email,
    password: 'azerty',
    is_coach: false,
    firstname: Faker::Name.first_name,
    description: Faker::Lorem.paragraph(sentence_count: 2),
    image_url: Faker::Avatar.image,
  )
end
puts "Clients créés"

clients.each do |client|
  plans = TrainingPlan.order(Arel.sql('RANDOM()')).limit(rand(2..4))
  plans.each do |plan|
    client.add_to_cart(plan.id)
  end
  
  purchased_plans = client.cartlist.sample(rand(1..client.cartlist.length))
  purchased_plans.each do |plan_id|
    UserTrainingPlan.create!(
      user: client,
      training_plan_id: plan_id,
      purchased: true
    )
    client.ordered << plan_id
  end
  client.save
end
puts "Programmes ajoutés aux paniers des clients."

puts "Seed terminé !"