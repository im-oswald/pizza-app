# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :find_order, only: %i[update]

  def index
    @orders = Order.active
  end

  def update
    @order.completed!

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("order_#{@order.uuid}") }
    end
  end

  private

  def find_order
    @order = Order.find(params[:id])
  end
end
