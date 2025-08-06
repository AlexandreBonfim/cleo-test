require 'change_calculator'

RSpec.describe ChangeCalculator do
  subject(:calculator) { described_class.new }

  it 'exists' do
    expect(defined? described_class).to be_truthy
  end

  context "with infinite coin supply" do

    it "returns correct coins for 212p" do
      expect(calculator.calculate(212)).to eq([200, 10, 2])
    end

    it "returns correct coins for 144p" do
      expect(calculator.calculate(144)).to eq([100, 20, 20, 2, 2])
    end

    it "returns empty array for 0p" do
      expect(calculator.calculate(0)).to eq([])
    end

    it "raises error for negative input" do
      expect { calculator.calculate(-5) }.to raise_error(ArgumentError)
    end
  end

  context "with limited coin inventory" do
    it "returns correct change when enough coins exist" do
      inventory = { 100 => 1, 10 => 2, 2 => 1 }
      calculator = described_class.new_with_inventory(inventory)

      expect(calculator.calculate(112)).to eq([100, 10, 2])
    end

    it "returns nil if exact change can't be made" do
      inventory = { 100 => 1, 10 => 0, 2 => 0 }
      calculator = described_class.new_with_inventory(inventory)

      expect(calculator.calculate(112)).to be_nil
    end

    it "handles edge case: not enough of largest coin" do
      inventory = { 100 => 1, 50 => 1, 2 => 2 }
      calculator = described_class.new_with_inventory(inventory)

      # 144 = 100 + 2 + 2 + 40 not possible
      expect(calculator.calculate(144)).to be_nil
    end
  end
end