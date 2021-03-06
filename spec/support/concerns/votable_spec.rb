require 'rails_helper'

RSpec.shared_examples_for 'votable' do
  let(:model) { described_class }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:votable) do
    if model.to_s == 'Answer'
      question = create(:question, user: user)
      create(model.to_s.underscore.to_sym, question: question, user: user)
    else
      create(model.to_s.underscore.to_sym, user: user)
    end
  end

  it '#vote_up' do
    votable.vote_up(other_user)
    expect(Vote.last.value).to eq 1
  end

  it '#vote_down' do
    votable.vote_down(other_user)
    expect(Vote.last.value).to eq -1
  end
end
