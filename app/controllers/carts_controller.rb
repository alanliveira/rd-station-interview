class CartsController < ApplicationController
  before_action :set_cart, except: %i[create]
  before_action :set_product, except: %i[show]
  before_action :set_cart_session, only: %i[create]

  def show; end

  def add_item
    result = Carts::AddItemService.call(
      cart: @cart,
      product: @product,
      quantity: cart_params[:quantity]
    )

    if result[:status] == :ok
      @cart = result[:cart]
      render :show, status: :ok
    elsif result[:status] == :info
      redirect_to cart_show_path
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def create
    result = Carts::AddProductService.call(
      cart: @cart,
      product: @product,
      quantity: cart_params[:quantity]
    )

    if result[:status] == :ok
      @cart = result[:cart]
      render :create, status: :created
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def destroy
    result = Carts::RemoveProductService.call(
      cart: @cart,
      product: @product
    )

    if result[:status] == :ok
      @cart = result[:cart]
      render :show, status: :ok
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  private

  def cart_params
    params.permit(:product_id, :quantity)
  end

  def set_cart
    @cart = Cart.find(session[:cart_id])
  end

  def set_cart_session
    @cart = Carts::CreateService.call(cart_id: session[:cart_id])
    session[:cart_id] = @cart.id if session[:cart_id].nil?
  end

  def set_product
    @product = Product.find(cart_params[:product_id])
  end
end
