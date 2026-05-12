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

    expect(command.execute %w[--port 4567 --root tmp/templates --assets tmp/assets --component tmp/components]).to eq 0
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

end
