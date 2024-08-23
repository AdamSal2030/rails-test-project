# frozen_string_literal: true

# script/run_rake_task.rb

Rails.logger.debug 'custom rake task started'

Rake::Task['setup:me'].invoke

Rails.logger.debug 'Seeding completed!'
