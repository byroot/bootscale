require 'spec_helper'

RSpec.describe Bootscale do
  describe '.require' do
    it 'raises a LoadError if no files were found' do
      expect {
        Bootscale.require 'foo.rb'
      }.to raise_error LoadError
    end
  end
end
