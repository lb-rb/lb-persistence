# frozen_string_literal: true

require 'spec_helper'

describe LB::Persistence, '#repository' do
  include_context 'settings'

  subject { object.repository(repository) }

  let(:object) { described_class.new(settings) }

  let(:repository) { class_double('repository', new: repository_instance) }
  let(:repository_instance) { double('repository instance') }

  it 'should return container' do
    expect(repository).to receive(:new).with(object.container)
    expect(subject).to be(repository_instance)
  end
end
