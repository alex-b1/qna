require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let(:mail) { DailyDigestMailer.digest(user) }
    let(:questions_yesterday) { create_list(:question, 2, :created_at_yesterday, user: user) }
    let(:questions_more_yesterday) { create_list(:question, 2, :created_at_more_yesterday, user: user) }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders only yesterday's questions" do
      questions_yesterday.each do |question|
        within 'a' do
          expect(mail.body.encoded).to have_content question.title
        end
      end

      questions_more_yesterday.each do |question|
        within 'a' do
          expect(mail.body.encoded).to_not have_content question.title
        end
      end
    end
  end
end
