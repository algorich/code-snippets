class Money
  attr_reader :amount

  def initialize(amount)
    @amount = amount
  end

  def self.from_s(amount)
    amount.gsub!(/[^\d]/, '').to_i if amount.is_a?(String)
    new(amount)
  end

  def to_s
    @amount.to_s
  end
end