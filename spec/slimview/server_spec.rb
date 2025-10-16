require 'spec_helper'

describe Slimview::Server do
  subject { described_class.new }

  describe '#app' do
    it 'returns a configures App' do
      expect(Slimview::App).to receive(:configure!)
        .with(port: 3000, root: 'templates', assets: 'templates/assets', locals: {})

      subject.app
    end
  end

  describe '#start' do
    let(:mock_app) { double Slimview::App, { run!: true } }

    it 'calls app.start!' do
      allow(subject).to receive(:app).and_return mock_app
      expect(mock_app).to receive(:run!)

      subject.start
    end
  end
end
