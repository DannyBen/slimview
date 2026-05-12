require 'fileutils'
require 'tmpdir'

describe Slimview::Command do
  subject(:command) { described_class.new }

  let(:server) { instance_double Slimview::Server }

  before do
    allow(server).to receive(:start)
  end

  it 'starts the server without arguments' do
    expect(Slimview::Server).to receive(:new)
      .with(port: nil, root: nil, assets: nil, components: nil)
      .and_return server
    expect(server).to receive(:start)

    expect(command.execute).to eq 0
  end

  it 'passes configured options to the server' do
    expect(Slimview::Server).to receive(:new)
      .with(port: 4567, root: 'tmp/templates', assets: 'tmp/assets', components: 'tmp/components')
      .and_return server
    expect(server).to receive(:start)

    expect(command.execute %w[--port 4567 --root tmp/templates --assets tmp/assets --components tmp/components]).to eq 0
  end

  it 'supports short options' do
    expect(Slimview::Server).to receive(:new)
      .with(port: 4567, root: 'tmp/templates', assets: 'tmp/assets', components: 'tmp/components')
      .and_return server
    expect(server).to receive(:start)

    expect(command.execute %w[-p 4567 -r tmp/templates -a tmp/assets -c tmp/components]).to eq 0
  end

  it 'prints help without starting the server' do
    expect(Slimview::Server).not_to receive(:new)

    exit_code = nil
    expect { exit_code = command.execute %w[--help] }
      .to output(/Usage:\n  slimview \[options\]/).to_stdout
    expect(exit_code).to eq 0
  end

  it 'prints the version without starting the server' do
    expect(Slimview::Server).not_to receive(:new)

    exit_code = nil
    expect { exit_code = command.execute %w[--version] }
      .to output("#{Slimview::VERSION}\n").to_stdout
    expect(exit_code).to eq 0
  end

  describe 'init' do
    around do |example|
      Dir.mktmpdir('slimview-command-spec') do |dir|
        @tmpdir = dir
        example.run
      end
    end

    it 'copies the starter workspace to the given path' do
      target = File.join(@tmpdir, 'site')

      exit_code = nil
      expect { exit_code = command.execute ['init', target] }
        .to output(/Initialized Slimview workspace in #{Regexp.escape(target)}/).to_stdout

      expect(exit_code).to eq 0
      expect(File).to exist File.join(target, 'templates/index.slim')
      expect(File).to exist File.join(target, 'templates/layout.slim')
      expect(File).to exist File.join(target, 'templates/components/card.slim')
      expect(File).to exist File.join(target, 'templates/assets/style.css')
      expect(File).to exist File.join(target, 'templates/assets/slimview.svg')
    end

    it 'defaults to the current directory' do
      Dir.chdir(@tmpdir) do
        expect { command.execute %w[init] }
          .to output(/Initialized Slimview workspace in #{Regexp.escape(@tmpdir)}/).to_stdout
      end

      expect(File).to exist File.join(@tmpdir, 'templates/index.slim')
    end

    it 'rejects a non-empty target directory' do
      target = File.join(@tmpdir, 'site')
      FileUtils.mkdir_p target
      File.write File.join(target, 'existing.txt'), 'keep'

      expect { command.execute ['init', target] }
        .to raise_error RuntimeError, "Directory is not empty: #{target}"
    end

    it 'rejects an existing file target' do
      target = File.join(@tmpdir, 'site')
      File.write target, 'not a directory'

      expect { command.execute ['init', target] }
        .to raise_error RuntimeError, "Path exists and is not a directory: #{target}"
    end

    it 'copies starter files into a non-empty target with --force' do
      target = File.join(@tmpdir, 'site')
      FileUtils.mkdir_p target
      File.write File.join(target, 'existing.txt'), 'keep'

      expect { command.execute ['init', target, '--force'] }
        .to output(/Initialized Slimview workspace in #{Regexp.escape(target)}/).to_stdout

      expect(File.read(File.join(target, 'existing.txt'))).to eq 'keep'
      expect(File).to exist File.join(target, 'templates/index.slim')
    end
  end
end
