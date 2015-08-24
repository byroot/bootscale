require 'bundler/setup'
require 'bootscale'
require 'pathname'
require 'tmpdir'

module TestHelpers
  def in_tmpdir(&block)
    Dir.mktmpdir('bootscale') { |dir| Dir.chdir(dir, &block) }
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.disable_monkey_patching!

  config.warnings = true

  config.order = :random
  config.include TestHelpers
  Kernel.srand config.seed
end
