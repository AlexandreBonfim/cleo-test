class ChangeCalculator
  COIN_DENOMINATIONS = [200, 100, 50, 20, 10, 5, 2, 1].freeze

  def self.new_with_inventory(inventory)
    new(inventory.keys.sort.reverse, inventory)
  end

  def initialize(denominations = COIN_DENOMINATIONS, inventory = nil)
    @denominations = denominations.sort.reverse
    @inventory = inventory # nil means infinite supply
  end


  # input: integer amount in pence
  # output: array of coin values (e.g., [100, 100, 10, 2])
  def calculate(amount)
    raise ArgumentError, "Amount must be non-negative" if amount < 0

    result = []
    remaining = amount

    @denominations.each do |coin|
      next if coin > remaining
      max_available = @inventory ? @inventory[coin].to_i : Float::INFINITY

      while remaining >= coin && result.count(coin) < max_available
        remaining -= coin
        result << coin
      end
    end

    remaining.zero? ? result : nil
  end
end
