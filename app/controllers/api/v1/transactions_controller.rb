module Api
  module V1
    class TransactionsController < ApplicationController
      before_action :get_user

      def order
        library_item = library_item(params[:item_name], true)
        return render_not_found('Item') unless library_item

        transaction = Transaction.new(user: @user, library_item: library_item, status: 'borrowed')

        if transaction.save
          render json: { message: 'Order placed successfully.' }, status: :ok
        else
          render json: { error: transaction.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      def return
        returned_items = []
        params[:items].each do |item|
          library_item = library_item(item, false)
          next if library_item.blank?

          transaction = @user
            .transactions
            .where(created_at: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)
            .find_by(library_item: library_item, status: 'borrowed')

          transaction.update!(status: 'return')
          returned_items << item
        end

        render json: { message: "#{returned_items.join(', ')} items returned successfully." }, status: :ok
      end

      private

      def get_user
        @user = User.find_by(id:  params[:user_id])

        render_not_found('User') unless @user
      end

      def library_item(item_name, availability)
        LibraryItem.find_by(
          '(lower(name) = ? OR lower(ref_id) = ?) AND availability = ?',
          item_name.downcase,
          item_name.downcase,
          availability
        )
      end

      def render_not_found(source)
        render json: { message: "#{source} not found." }, status: :not_found
      end
    end
  end
end
