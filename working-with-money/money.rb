class Money
  attr_reader :amount

  def initialize(amount)
    @amount = amount
  end

  def self.to_i(amount)
    amount.gsub!(/[^\d]/, '').to_i if amount.is_a?(String)
    new(amount)
  end
end