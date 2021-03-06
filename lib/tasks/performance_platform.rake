require 'performance_platform'

namespace :performance_platform do
  desc 'Performance Platform transaction submission'
  task submit: :environment do
    Rake::Task['performance_platform:submit_transactions'].invoke
    Rake::Task['performance_platform:submit_user_satisfaction'].invoke
  end

  task submit_transactions: :environment do
    yesteday = Date.current.beginning_of_day - 1.day
    PerformancePlatformFeedbackQueueJob.perform_later(yesteday.to_s)
  end

  task submit_user_satisfaction: :environment do
    yesterday = Date.current.beginning_of_day - 1.day
    PerformancePlatformTransactionsQueueJob.perform_later(yesterday.to_s)
  end

  task submit_data_up_to_today: :environment do
    start_date = Date.parse('20/04/2018')
    current_date = Date.current
    number_of_days = current_date.mjd - start_date.mjd

    while number_of_days.positive?
      date = Date.current.beginning_of_day - number_of_days.day
      PerformancePlatformFeedbackQueueJob.perform_later(date.to_s)
      PerformancePlatformTransactionsQueueJob.perform_later(date.to_s)
      number_of_days -= 1
    end
  end
end
