require 'ruby-progressbar'

namespace :db do
  desc "Add things"
  task :add_things, [:count] => [:environment] do |t, args|
    args.with_defaults(count: 10)
    puts "Creating #{args[:count]} things"
    progressbar = ProgressBar.create(total: args[:count].to_i,
                                     format: '%a |%b %i| %p%%')
    FactoryGirl.build_list(:thing_faker, args[:count].to_i) do |m|
      progressbar.increment
      puts 'You are the luckiest person ever! One record had invalid title' unless m.save
    end
    puts "Done! Now you have #{ Thing.count } things in the database!"
  end
end
