require 'spec_helper'

describe Slimview::Server do
  subject { described_class.new }

  describe '#app' do
    it 'returns a configures App' do
      expect(Slimview::App).to receive(:configure!)
        .with(port: 3000, root: 'templates', assets: 'templates/assets', components: 'templates/components', locals: {})

      subject.app
    end

    context 'with SLIMVIEW_COMPONENTS' do
      around do |example|
        previous_components = ENV['SLIMVIEW_COMPONENTS']
        ENV['SLIMVIEW_COMPONENTS'] = 'custom/components'
        example.run
      ensure
        ENV['SLIMVIEW_COMPONENTS'] = previous_components
      end

      it 'uses the configured components directory' do
        expect(Slimview::App).to receive(:configure!)
          .with(port: 3000, root: 'templates', assets: 'templates/assets', components: 'custom/components', locals: {})

        subject.app
      end
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
