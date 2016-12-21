RSpec::Matchers.define :be_an_absolute_path do
  match do |actual|
    actual && actual == File.expand_path(actual)
  end
end
