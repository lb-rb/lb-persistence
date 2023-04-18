# frozen_string_literal: true

if ENV['COVERAGE'] == 'true'
  require 'simplecov'

  SimpleCov.start do
    command_name 'spec:unit'

    add_filter 'config'
    add_filter 'spec'

    minimum_coverage 88
  end
end

$LOAD_PATH << 'lib'

require 'lb-persistence'

# require spec support files and shared behavior
Dir[File.expand_path('{support,shared}/**/*.rb', __dir__)].sort.each do |file|
  require file
end

RSpec.configure do |config|
  config.include(SpecHelper)
  config.mock_framework = :rspec
end
