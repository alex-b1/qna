require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'commentable'
  it_behaves_like 'linkable'
  it_behaves_like 'votable'

  it { should belong_to :question}
  it { should belong_to :user}

  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
