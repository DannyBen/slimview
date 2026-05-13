describe Slimview::Renderer do
  subject(:renderer) { described_class.new root: root }

  let(:root) { 'spec/fixtures/templates' }

  it 'renders the index page through the Rack app' do
    html = renderer.render

    expect(html).to include 'Slimview layout is included'
    expect(html).to include 'Slimview template is working'
    expect(html).to include 'This is a partial snippet'
  end

  it 'raises when the template does not exist' do
    expect { renderer.render '/missing' }
      .to raise_error RuntimeError, 'Template not found: missing'
  end
end
