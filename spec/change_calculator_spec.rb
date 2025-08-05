require 'change_calculator'

RSpec.describe ChangeCalculator do
  subject(:calculator) { described_class.new }

  it 'exists' do
    expect(defined? described_class).to be_truthy
  end

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

