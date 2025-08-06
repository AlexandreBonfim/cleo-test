require 'vending_machine'
require 'product'

RSpec.describe VendingMachine do
  let(:products) do
    [
      Product.new(id: 1, name: "Coke", price: 120, stock: 2),
      Product.new(id: 2, name: "Water", price: 90, stock: 0)
    ]
  end
  let(:coin_inventory) { { 100 => 1, 20 => 1, 10 =>1 , 2 => 2 } }

  subject(:machine) { described_class.new(products: products, coin_inventory: coin_inventory) }

  it "completes a purchase and returns correct change" do
    machine.insert_coin(100)
    machine.insert_coin(50)

    result = machine.select_product(1)

    expect(result[:product]).to eq("Coke")
    expect(result[:change]).to eq([20, 10])
  end

  it "raises if coin is invalid" do
    expect {
      machine.insert_coin(400)
    }.to raise_error(ArgumentError, "Invalid coin")
  end

  it "raises if product is not found" do
    machine.insert_coin(100)
    expect { machine.select_product(3) }.to raise_error("Product not found")
  end

  it "raises if product is out of stock" do
    machine.insert_coin(100)
    machine.insert_coin(50)
    expect { machine.select_product(2) }.to raise_error("Out of stock")
  end

  it "raises with how much more is needed when not enough money inserted" do
    machine.insert_coin(100)
    expect {
      machine.select_product(1)
    }.to raise_error("Insufficient funds: please insert 20p more")
  end

   it "raises if not enough coins to make change" do
    machine.insert_coin(200)
    expect { machine.select_product(1) }.to raise_error("Cannot return change")
  end

  describe "restock_coins" do
    it "adds coins to the existing inventory" do
      expect {
        machine.restock_coins({ 20 => 2, 10 => 1 })
      }.to change { machine.instance_variable_get(:@coin_inventory)[20] }.by(2)
    end

    it "raises error for negative quantity" do
      expect {
        machine.restock_coins({ 20 => -1 })
      }.to raise_error(ArgumentError, "Quantity must be non-negative")
    end
  end

  describe "restock_products" do
    it "increases stock for existing products" do
      expect {
        machine.restock_products([Product.new(id: 1, name: "Coke", price: 120, stock: 3)])
      }.to change { machine.instance_variable_get(:@products)[1].stock }.by(3)
    end

    it "adds new products if they don’t exist" do
      machine.restock_products([Product.new(id: 3, name: "Juice", price: 150, stock: 2)])
      product = machine.instance_variable_get(:@products)[3]
      expect(product.name).to eq("Juice")
      expect(product.stock).to eq(2)
    end

    it "raises error for negative stock" do
      expect {
        machine.restock_products([Product.new(id: 4, name: "Tea", price: 80, stock: -1)])
      }.to raise_error(ArgumentError, "Stock must be non-negative")
    end
  end
end
