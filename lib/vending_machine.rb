require_relative 'change_calculator'
require_relative 'product'

class VendingMachine
  def initialize(products:, change_calculator: ChangeCalculator.new)
    @products = products.map { |p| [p.id, p] }.to_h
    @inserted_amount = 0
    @change_calculator = change_calculator
  end

  def insert_coin(value)
    raise ArgumentError, "Invalid coin" unless ChangeCalculator::COIN_DENOMINATIONS.include?(value)
    @inserted_amount += value
  end

  def select_product(product_id)
    product = @products[product_id]
    raise "Product not found" unless product
    raise "Out of stock" if product.stock.zero?

    ensure_sufficient_funds!(product)

    change_amount = @inserted_amount - product.price
    change = @change_calculator.calculate(change_amount)

    raise "Cannot return change" unless change

    product.stock -= 1
    @inserted_amount = 0

    { product: product.name, change: change }
  end

  private

  def ensure_sufficient_funds!(product)
    if @inserted_amount < product.price
      missing = product.price - @inserted_amount
      raise "Insufficient funds: please insert #{missing}p more"
    end
  end
end