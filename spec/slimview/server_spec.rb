require 'spec_helper'

describe Slimview::Server do
  subject { described_class.new }

  describe '#app' do
    it 'returns a configured App', :aggregate_failures do
      app = subject.app

      expect(app).to be < Slimview::App
      expect(app.settings.port).to eq 3000
      expect(app.settings.views).to eq File.expand_path('templates', Dir.pwd)
      expect(app.settings.public_folder).to eq File.expand_path('templates/assets', Dir.pwd)
      expect(app.settings.slimview_components).to eq File.expand_path('templates/components', Dir.pwd)
      expect(app.settings.raise_errors).to be false
      expect(app.settings.show_exceptions).to be true
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
        app = subject.app

        expect(app.settings.slimview_components).to eq File.expand_path('custom/components', Dir.pwd)
      end
    end

    context 'with raise_errors' do
      subject { described_class.new raise_errors: true }

      it 'disables Sinatra error pages' do
        app = subject.app

        expect(app.settings.raise_errors).to be true
        expect(app.settings.show_exceptions).to be false
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
