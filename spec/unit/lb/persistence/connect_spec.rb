# frozen_string_literal: true

require 'spec_helper'

describe LB::Persistence, '#connect' do
  include_context 'settings'

  subject { object.connect(database_uri) }

  let(:object) { described_class.new(settings) }

  it 'should return container' do
    expect(subject).to be_a(Sequel::SQLite::Database)
  end
end
