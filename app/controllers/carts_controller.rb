class CartsController < ApplicationController
  before_action :set_cart, only: %i[show add_item destroy]

  ## TODO Escreva a lógica dos carrinhos aqui
  def show; end

  def add_item; end

  def create; end

  private

  def destroy; end

  def set_cart = @cart = ShoppingCart.find(params[:id])

  def cart_params = params.permit(:product_id, :quantity)
end
