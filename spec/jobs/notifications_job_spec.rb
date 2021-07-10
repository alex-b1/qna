require 'rails_helper'

RSpec.describe NotificationService, type: :job do
  let(:service) { double(NotificationService) }

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  before do
    allow(NotificationService).to receive(:new).and_return(service)
  end

  it 'calls NotificationsService#send_notification' do

    expect(service).to receive(:send_notification)
    NotificationsJob.perform_now(answer)
    end
end
