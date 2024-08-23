# frozen_string_literal: true

namespace :setup do
  desc 'Create objects for all table'
  task me: :environment do
    puts 'im in custom rake task'
    teams = FactoryBot.create_list(:team, 5)

    puts 'Teams created'

    members = teams.map do |team|
      FactoryBot.create(:member, team:)
    end

    puts 'Member created with team'

    projects = FactoryBot.create_list(:project, 5)
    puts 'Projects created'

    members.each_with_index do |member, index|
      project = projects[index]
      member.projects << project
      puts "Assigned member #{member.id} to project #{project.id}"
    end
  end
end
