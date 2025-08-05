require 'vending_machine'
require 'product'

RSpec.describe VendingMachine do
  let(:products) do
    [
      Product.new(id: 1, name: "Coke", price: 120, stock: 2),
      Product.new(id: 2, name: "Water", price: 90, stock: 0)
    ]
  end

  subject(:machine) { described_class.new(products: products) }

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
end
