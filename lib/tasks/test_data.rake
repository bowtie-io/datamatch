namespace :test_data do
  task :populate => :environment do
    return if Rails.env.production?

    profiles = []

    200.times do |idx|
      profiles << Profile.create({
        name: Faker::Name.name,
        bowtie_user_id: idx,
        bowtie_project_id: 22,
        info: Faker::Lorem.paragraphs(rand(5)),
        email: Faker::Internet.email,
        category: %w(tester startup).sample,
        tag_name_array: "Frontend, Backend, Full-Stack, UX Design, UI Design, Mobile Dev, Student, DevOps, Copywriter, Branding, Marketer, Biz Dev, Investor".split(',').map(&:strip)
      })
    end

    profiles.each do |profile|
      rand(10).times do
        match_profile = Profile.where('category != ?', profile.category).first
        next unless match_profile

        Match.create(left_profile: profile,
                     right_profile: match_profile,
                     left_profile_matched_at: Time.now - rand(3600).minutes,
                     right_profile_matched_at: (rand(1) > 0 ? Time.now - rand(3600).minutes : nil),
                     left_profile_notified_at: (rand(1) > 0 ? Time.now : nil),
                     right_profile_notified_at: (rand(1) > 0 ? Time.now : nil))
      end
    end
  end
end
