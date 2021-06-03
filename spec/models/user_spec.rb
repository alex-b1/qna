require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  describe 'Check authorship' do
    let(:user) { create(:user) }
    let(:author) { create(:user) }
    let(:question) { create(:question, user: author) }

    it 'current user is an author' do
      expect(author).to be_author(question)
    end

    it 'current user is not an author' do
      expect(user).to_not be_author(question)
    end
  end
end
