# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :find_order, only: %i[update]

  def index
    @orders = Order.active.order(created_at: :desc)
  end

  def update
    @order.completed!

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("order_#{@order.uuid}",
                                                 partial: 'shared/flash_message',
                                                 locals: { message: 'Order completed successfully.', type: 'success' })
      end
    end
  end

  private

  def find_order
    @order = Order.find(params[:id])
  end
end
