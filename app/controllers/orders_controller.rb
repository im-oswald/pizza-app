# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :find_order, only: %i[update]

  def index
    @orders = Order.active
  end

  def update
    @order.update!(order_params)
  end

  private

  def find_order
    @order = Order.find(params[:id])
  end
end
