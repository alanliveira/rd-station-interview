require 'rails_helper'

RSpec.describe "/cart", type: :request do
  let(:json) { JSON.parse(response.body) }

  describe 'POST /' do
    let!(:product) { create(:product) }

    context 'when the cart does not exist' do
      subject { post '/cart', params: { product_id: product.id, quantity: 1 }, as: :json }

      it 'creates a new cart' do
        expect { subject }.to change(Cart, :count).by(1)
      end

      it 'returns status 201' do
        subject
        expect(response).to have_http_status(:created)
      end

      it 'stores cart_id in session' do
        subject
        expect(session[:cart_id]).to be_present
      end

      it 'stores correct cart_id in session' do
        subject
        expect(session[:cart_id]).to eq(Cart.last.id)
      end
    end

    context 'when the cart already exists' do
      include_context 'session double'

      let!(:cart) { create(:cart, :with_shopping_cart) }
      let!(:product) { create(:product) }

      let(:session_hash) { {} }

      before do
        session_hash[:cart_id] = cart.id
      end

      subject do
        post '/cart',
             params: { product_id: product.id, quantity: 1 },
             as: :json
      end

      it 'returns status 200' do
        subject
        expect(response).to have_http_status(:created)
      end

      it 'does not create a new cart' do
        expect { subject }.not_to change(Cart, :count)
      end

      it 'keeps the same cart_id in session' do
        subject
        expect(session[:cart_id]).to eq(cart.id)
      end
    end

    context 'when the response 404' do
      it 'return status not_found' do
        post '/cart',
             params: { product_id: -1, quantity: 1 },
             as: :json
        expect(response).to have_http_status(:not_found)
      end

      it 'return quantity less or equal to 0' do
        post '/cart',
             params: { product_id: -1, quantity: 0 },
             as: :json

        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the response 201' do
      include_context 'session double'

      before do
        session_hash[:cart_id] = cart.id
      end

      let!(:cart) { create(:cart, :with_shopping_cart) }
      let!(:product) { create(:product) }

      let(:session_hash) { {} }

      subject do
        post '/cart',
             params: { product_id: product.id, quantity: 1 },
             as: :json
      end

      it 'returns cart json' do
        subject

        expect(json).to have_key('id')
        expect(json).to have_key('total_price')
        expect(json).to have_key('products')

        expect(json['products']).to be_an(Array)
        expect(json['products'].size).to eq(1)
        expect(json['products'].first['quantity']).to eq(1)
        expect(json['products'].first['total_price']).to eq(product.price)

        item = json['products'].first
        expect(item).to include('quantity', 'unit_price', 'total_price')
      end
    end
  end

  describe 'GET /' do
    include_context 'session double'

    before do
      session_hash[:cart_id] = cart.id
    end

    let!(:cart) { create(:cart, :with_shopping_cart) }
    let!(:product) { create(:product, price: 35.0) }
    let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

    subject { get '/cart', as: :json }

    context 'when the response 200' do
      it 'returns cart json' do
        subject

        expect(json).to have_key('id')
        expect(json).to have_key('total_price')
        expect(json).to have_key('products')

        expect(json['products']).to be_an(Array)
        expect(json['products'].size).to eq(1)
        expect(json['products'].first['quantity']).to eq(1)
        expect(json['products'].first['total_price']).to eq(35.0)

        item = json['products'].first
        expect(item).to include('quantity', 'unit_price', 'total_price')
      end
    end

    context 'when the response 404' do
      before do
        session_hash[:cart_id] = nil
      end

      it 'return status not_found' do
        subject

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "PUT /add_items" do
    include_context 'session double'

    before do
      session_hash[:cart_id] = cart.id
    end

    let!(:cart) { create(:cart, :with_shopping_cart) }
    let(:product) { create(:product, name: "Test Product", price: 10.0) }
    let(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

    context 'when the product already is in the cart' do
      subject do
        put '/cart/add_item', params: { product_id: product.id, quantity: 1 }, as: :json
        put '/cart/add_item', params: { product_id: product.id, quantity: 1 }, as: :json
      end

      it 'updates the quantity of the existing item in the cart' do
        expect { subject }.to change { cart_item.reload.quantity }.by(2)

        subject

        expect(response).to have_http_status(:ok)
        expect(json['products']).to be_an(Array)
        expect(json['products'].size).to eq(1)
        expect(json['products'].first['quantity']).to eq(3)
        expect(json['products'].first['total_price']).to eq(30.0)
      end
    end

    context 'when the product is not in the cart' do
      let(:new_product) { create(:product, name: "New Product test", price: 20.0) }

      subject do
        put '/cart/add_item', params: { product_id: new_product.id, quantity: 1 }, as: :json
      end

      it 'redirect to POST /cart' do
        subject

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(cart_show_path)
      end
    end
  end

  describe "DELETE /:product_id" do
    include_context 'session double'

    before do
      session_hash[:cart_id] = cart.id
    end

    let!(:cart) { create(:cart, :with_shopping_cart) }
    let!(:product1) { create(:product) }
    let!(:product2) { create(:product) }
    let!(:cart_item1) { create(:cart_item, cart: cart, product: product1, quantity: 1) }
    let!(:cart_item2) { create(:cart_item, cart: cart, product: product2, quantity: 1) }

    context 'when the product is in the cart' do
      subject do
        delete "/cart/#{product1.id}", params: { product_id: product1.id }, as: :json
      end

      it 'removes the item from the cart' do
        expect { subject }.to change(CartItem, :count).by(-1)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the response 200' do
      subject do
        delete "/cart/#{product1.id}", params: { product_id: product1.id }, as: :json
      end

      it 'returns cart json' do
        subject

        expect(json).to have_key('id')
        expect(json).to have_key('total_price')
        expect(json).to have_key('products')

        expect(json['products']).to be_an(Array)
        expect(json['products'].size).to eq(1)

        item = json['products'].first
        expect(item).to include('quantity', 'unit_price', 'total_price')
      end
    end

    context 'when remove all items from the cart' do
      subject do
        delete "/cart/#{product1.id}", as: :json
        delete "/cart/#{product2.id}", as: :json
      end

      it 'removes all items from the cart' do
        expect { subject }.to change(CartItem, :count).by(-2)

        expect(response).to have_http_status(:ok)
        expect(json['products'].size).to eq(0)
        expect(json['total_price']).to eq(0.0)
      end
    end
  end
end
