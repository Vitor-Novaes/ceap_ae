# frozen_string_literal: true

desc 'Linter with rubocop and erblint'
task :lint do
  if system('bundle exec rubocop --rails --parallel && bundle exec erblint app/views/**/*.erb')
    exit 0
  else
    puts 'Lint failed'
    exit 1
  end
end
