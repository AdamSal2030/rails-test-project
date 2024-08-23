# frozen_string_literal: true

FactoryBot.define do
  factory :member do
    association :team
    first_name { 'Adam' }
    last_name { 'Sal' }
    city { 'LHE' }
    state { 'punjab' }
    country { 'Pakistan' }
  end
end
