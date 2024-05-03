require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  let(:user) { create(:user, subscription: build(:subscription)) }
  let(:library_item) { create(:library_item) }

  describe '#order' do
    context 'with valid params' do
      it 'creates a new transaction' do
        post :order, params: { user_id: user.id, item_name: library_item.name }

        expect(response).to have_http_status(:ok)
        expect(user.transactions.count).to eq(1)
      end
    end

    context 'with invalid params' do
      it 'returns error message' do
        post :order, params: { user_id: user.id, item_name: 'invalid_item_name' }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['message']).to eq('Item not found.')
      end
    end

    context 'with invalid user age and book genrea is crime' do
      it 'returns error message' do
        library_item.update!(genre: 'Crime')
        user.update!(age: 17)

        post :order, params: { user_id: user.id, item_name: library_item.name }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('User is under age to read the crime books.')
      end
    end
  end

  describe '#return' do
    context 'with valid params' do
      it 'updates transaction status and returns success message' do
        transaction = create(:transaction, user: user, library_item: library_item, status: 'borrowed')
        library_item.update(availability: false)

        post :return, params: { user_id: user.id, items: [library_item.name] }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq("#{library_item.name} items returned successfully.")
        expect(transaction.reload.status).to eq('return')
      end
    end

    context 'with invalid params' do
      it 'returns error message' do
        post :return, params: { user_id: user.id, items: ['invalid_item_name'] }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['message']).to eq('Items not found.')
      end
    end
  end
end
