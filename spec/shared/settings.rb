# frozen_string_literal: true

shared_context 'settings' do
  def root_for(file, depth = 2)
    path = File.expand_path(file)
    depth.times { path = File.dirname(path) }
    path
  end

  let(:root) { root_for(__FILE__, 3) }

  let(:source_dir) { File.join(root, 'spec/fixtures/lib/example/persistence') }

  let(:namespace) { 'Test::Persistence' }

  let(:database_uri) { 'sqlite::memory' }
  let(:settings) do
    LB::Persistence::Settings.new(
      source_dir: root,
      namespace: namespace,
      database_uri: database_uri
    )
  end
end
