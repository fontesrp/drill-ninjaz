# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

PASSWORD = 'supersecret'

User.destroy_all
DrillGroup.destroy_all
Question.destroy_all
Solution.destroy_all
Attempt.destroy_all

super_user = User.create(
  first_name: 'Leo',
  last_name: 'Nardo',
  email: 'leo@ninja.com',
  password: PASSWORD,
  is_admin: true,
  activated: true,
  activated_at: Time.zone.now
)

second_admin = User.create(
  first_name: 'Max',
  last_name: 'Power',
  email: 'max-power@ninja.com',
  password: PASSWORD,
  is_admin: true
)

10.times do |num|
  full_name = Faker::SiliconValley.character.split(' ')
  first_name = full_name[0]
  last_name = full_name[1]

  User.create(
    first_name: first_name,
    last_name: last_name,
    email: "#{first_name}.#{last_name}-#{num}@ninja.com",
    password: 'supersecret',
    activated: true,
    activated_at: Time.zone.now
  )
end

users = User.all


15.times.each do |num|
  points = rand(10..300)
  score = rand(10..300)
  level = ['beginner', 'intermediate', 'advanced'][rand(0..2)]
  d = DrillGroup.create({
    name: Faker::ProgrammingLanguage.name,
    description: Faker::StarWars.quote,
    points: points,
    level: level,
    user: User.first
  })

  # Create random number of Questions on the valid Drill Groups
  if d.valid?
    rand(1..10).times.each do |quest|
      q = Question.create(
        description: "This is question ##{quest + 1}",
        language: Question::VALID_LANGUAGES.sample,
        drill_group: d
      )

      # Create random number of solutions on the valid Questions
      if q.valid?
        rand(1..3).times.each do |sol|
          s = Solution.create(
            answer: "Solution ##{sol + 1}",
            question: q
          )
        end
        if q.valid?
          rand(1..7).times.each
            Attempt.create(
              user: users.sample,
              drill_group: d,
              score: score,
              current_question: q,
            )
        end
      end
    end
  end
end

puts Cowsay.say "Created #{User.count} users", :frogs
puts Cowsay.say "Created #{DrillGroup.count} Drill Groups", :sheep
puts Cowsay.say "Created #{Question.count} Questions", :tux
puts Cowsay.say "Created #{Solution.count} Solutions", :cow
puts Cowsay.say "Created #{Attempt.count} Attempts", :tux
puts "Login as admin with #{super_user.email} and password of '#{PASSWORD}'!"
puts "Second admin user with #{second_admin.email} and password of #{PASSWORD}"
