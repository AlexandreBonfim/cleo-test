require_relative 'change_calculator'
require_relative 'product'

class VendingMachine
  def initialize(products:, coin_inventory:)
    @products = products.map { |p| [p.id, p] }.to_h
    @coin_inventory = coin_inventory # { 100 => 2, 50 => 1, etc. }
    @inserted_amount = 0
  end

  def insert_coin(value)
    raise ArgumentError, "Invalid coin" unless ChangeCalculator::COIN_DENOMINATIONS.include?(value)
   
    @inserted_amount += value
    @coin_inventory[value] ||= 0
    @coin_inventory[value] += 1
  end

  def select_product(product_id)
    product = @products[product_id]
  
    raise "Product not found" unless product
    raise "Out of stock" if product.stock.zero?

    ensure_sufficient_funds!(product)

    change_amount = @inserted_amount - product.price
    calculator = ChangeCalculator.new_with_inventory(@coin_inventory)
    change = calculator.calculate(change_amount)

    raise "Cannot return change" unless change

    # Deduct coins used for change
    change.each do |coin|
      @coin_inventory[coin] -= 1
    end

    product.stock -= 1
    @inserted_amount = 0

    { product: product.name, change: change }
  end

  def restock_coins(new_coins)
    new_coins.each do |coin, qty|
      raise ArgumentError, "Quantity must be non-negative" if qty < 0
     
      @coin_inventory[coin] ||= 0
      @coin_inventory[coin] += qty
    end
  end

  def restock_products(new_products)
    new_products.each do |new_product|
      raise ArgumentError, "Stock must be non-negative" if new_product.stock < 0

      existing = @products[new_product.id]

      if existing
        existing.stock += new_product.stock
      else
        @products[new_product.id] = new_product
      end
    end
  end

  def coin_inventory
    @coin_inventory.dup
  end
  
  def product_inventory
    @products.transform_values do |p|
      { name: p.name, price: p.price, stock: p.stock }
    end
  end
  
  private

  def ensure_sufficient_funds!(product)
    if @inserted_amount < product.price
      missing = product.price - @inserted_amount
      raise "Insufficient funds: please insert #{missing}p more"
    end
  end
end