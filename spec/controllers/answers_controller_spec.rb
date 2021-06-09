require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user){ create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #mark_as_best' do
    context 'author of the question' do
      before { login(user) }

      it 'updates answer best field' do
        post :mark_as_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer.best).to be true
      end
    end

    context 'not author of the question' do
      before { login(other_user) }

      it 'not updates answer best field' do
        post :mark_as_best, params: { id: answer }, format: :js
        answer.reload
        expect(answer.best).to be false
      end
    end
  end

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: {answer: attributes_for(:answer), question_id: question}, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: {question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'author update this answer'
      before { login(user) }

      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update template' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update template' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end

    context 'user is not author' do
      before { login(other_user)}

      it 'tries to update answer' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user )}

    context 'user is author' do
      before { login(user) }

      it 'check that answer was deleted' do
        delete :destroy, params: { id: answer }, format: :js
        expect(assigns(:answer)).to be_destroyed
      end

      it 'renders destroy teplate' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'user is not author' do
      let(:other_user) { create(:user) }
      before { login(other_user) }

      it 'tries to delete answer' do
        expect { delete :destroy, params: { id: answer}, format: :js }.to_not change(Answer, :count)
      end
    end

    context 'unauthorized user' do
      it 'tries to delete answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end
    end
  end
end