class ChangeCalculator
  COIN_DENOMINATIONS = [200, 100, 50, 20, 10, 5, 2, 1].freeze

  def initialize(denominations = COIN_DENOMINATIONS)
    @denominations = denominations
  end

  # input: integer amount in pence
  # output: array of coin values (e.g., [100, 100, 10, 2])
  def calculate(amount)
    raise ArgumentError, "Amount must be non-negative" if amount < 0

    result = []
    @denominations.each do |coin|
      while amount >= coin
        amount -= coin
        result << coin
      end
    end
    result
  end
end
  
