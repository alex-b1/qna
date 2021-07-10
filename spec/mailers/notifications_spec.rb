require "rails_helper"

RSpec.describe NotificationsMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:subscription) { create(:subscription, question: question, user: user) }
  let(:mail) { NotificationsMailer.notifications(user, answer) }

  it 'renders headers' do
    expect(mail.subject).to eq ("Notifications")
    expect(mail.to).to eq([user.email])
    expect(mail.from).to eq(["from@example.com"])
  end

  it "renders answer body" do
    expect(mail.body.encoded).to match(answer.body)
  end
end
