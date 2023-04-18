# frozen_string_literal: true

namespace :metrics do
  desc 'Check code style with RuboCop'
  task :rubocop do
    require 'rubocop'
    begin
      # args = %W[--config #{config.config_file}]
      args = []
      raise 'Rubocop failed' unless RuboCop::CLI.new.run(args).zero?
    rescue Encoding::CompatibilityError => e
      abort e.message
    end
  end
end

desc 'Run CI tasks'
task ci: %w[ci:metrics]

namespace :ci do
  tasks = %w[
    metrics:rubocop
    spec:integration
  ]

  desc 'Run metrics'
  task metrics: tasks
end
