ENV.each_key do |key|
    env key.to_sym, ENV[key]
end

set :environment, ENV["RAILS_ENV"]

every 1.minute do # 1.minute 1.day 1.week 1.month 1.year is also supported
    runner "Message.reindex"
end