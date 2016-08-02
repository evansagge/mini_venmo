# Public: Luhn validation (taken from https://en.wikipedia.org/wiki/Luhn_algorithm).
# The formula verifies a number against its included check digit, which is usually appended to a partial account number
# to generate the full account number. This number must pass the following test:
#
# 1. From the rightmost digit, which is the check digit, moving left, double the value of every second digit;
#    if the product of this doubling operation is greater than 9 (e.g., 8 * 2 = 16),
#    then sum the digits of the products (e.g., 16: 1 + 6 = 7, 18: 1 + 8 = 9).
# 2. Take the sum of all the digits.
# 3. If the total modulo 10 is equal to 0 (if the total ends in zero) then the number is valid according to the Luhn formula;
#    else it is not valid.
class Luhn
  attr_reader :value

  # Returns true if the string is a valid Luhn 10 string; otherwise, false.
  # Examples:
  #   valid?('4111111111111111')
  #   # => true
  #   valid?('1234567890123456')
  #   # => false
  def self.valid?(value)
    new(value).valid?
  end

  def initialize(value)
    @value = value
  end

  def valid?
    valid_number? && luhn_modulo.zero?
  end

  private

  def valid_number?
    digits.any?
  end

  def luhn_modulo
    luhn_sum % 10
  end

  def luhn_sum
    luhn_doubles.reduce(:+)
  end

  def luhn_doubles
    numbers = digits.slice(0..-2).reverse.map.with_index do |digit, index|
      digit *= 2 if index.even?
      digit.divmod(10).reduce(:+)
    end
    numbers << digits.last
    numbers
  end

  def digits
    value.scan(/\d/).map(&:to_i)
  end
end
