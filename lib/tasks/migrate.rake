namespace :migrate do
  task :tmp => :environment do
    require 'mysql2'
    users = []

    client = Mysql2::Client.new(host: 'localhost', username: 'root', database: 'datamatch_migration')

    client.query("select * from users").each do |user|
      client.query("select * from details where user_sid = '#{user['sid']}'").each do |details|
        user['info'] = details['user_details']
        user['tag_name_array'] = (details['tags'] || '').split(',').map(&:strip)
        user['plan'] = details['plan']
      end

      user['matches'] = []

      client.query("select * from matches where user_id = '#{user['sid']}' order by created_at asc").each do |match|
        user['matches'] << match
      end

      users << user
    end

    puts users.to_json
  end

  task :from_old_schema => :environment do
    user_sid_to_profile = {}
    users = JSON.load(File.read('migration_data.json'))

    users.each do |user|
      category = {
        'Tester'        => 'tester',
        'Startup'       => 'startup',
        'Startup - Pro' => 'startup'
      }[user['plan']]

      profile = Profile.create({
        bowtie_user_id: user['bowtie_id'],
        bowtie_project_id: 22,
        created_at: user['created_at'],
        updated_at: user['updated_at'],
        category: category,
        name: user['name'],
        email: user['email'],
        info: user['info'],
        tag_name_array: user['tag_name_array'],
        last_potential_match_created_at: nil
      })

      user_sid_to_profile[user['sid']] = profile
    end

    users.each do |user|
      matches = user['matches']
      profile = user_sid_to_profile[user['sid']]

      matches.each do |match|
        match_profile = user_sid_to_profile[match['matched_id']]

        if match['decision'] == 1
          puts "matching #{profile.name} with #{match_profile.name}"
          profile.match_with(match_profile)
        else
          puts "not matching #{profile.name} with #{match_profile.name}"
          profile.update_column(:last_potential_match_created_at, Time.parse(match['created_at']))
        end
      end
    end
  end

  task :plan_updates => :environment do
    users = JSON.load(File.read('migration_data.json'))

    users.each do |user|
      profile = Profile.find_by(email: user['email'])

      category = {
        'Tester'        => 'tester',
        'Startup'       => 'startup',
        'Startup - Pro' => 'startup'
      }[user['plan']]

      profile.update_column(:category, category)
    end
  end

  task :push_profile_data_to_bowtie => :environment do
    require 'rest-client'

    Profile.find_each do |profile|
      begin
        resource =  RestClient::Resource.new('https://promdate.io/bowtie/api/users/profile.json', {
          user: profile.bowtie_user_id,
          password: Rails.configuration.bowtie_project_secret_key
        })

        resource.post profile: {
          info: profile.info,
          tags: profile.tag_name_array.join(', ')
        }
      rescue RestClient::ResourceNotFound
      end
    end
  end
end
