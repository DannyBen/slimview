require 'spec_helper'

describe Slimview do
  subject { described_class.new }

  describe '#initialize' do
    it 'sets the default port to 3000' do
      expect(subject.instance_variable_get(:@port)).to eq(3000)
    end

    it 'sets the default root to "templates"' do
      expect(subject.instance_variable_get(:@root)).to eq('templates')
    end

    it 'initializes with empty locals' do
      expect(subject.instance_variable_get(:@locals)).to eq({})
    end
  end
end
