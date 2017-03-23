function numberToCurrency(number) {
  var options  = $('#number-to-currency-data').data('options');

  if (!options) throw('You should define a element with id="number-to-currency-data" and data attributes');

  if (typeof number === 'string')
    number = parseInt(number.replace(/[^\d]/g, '')) / 100.0
  else if (typeof number === 'number' && number % 1 === 0) // integer
    number = number / 100.0
  else if (typeof number === 'number' && number % 1 !== 0) // float
    number // float is what we want
  else
    throw("Not recognized number");

  var unit      = options.unit,
      format    = options.format,
      separator = options.separator,
      delimiter = options.delimiter;

  if (number < 0) number = Math.abs(number);

  if (isNaN(number)) number = '0';

  var cents = Math.floor((number * 100 + 0.5) % 100);
  if (cents < 10) cents = '0' + cents;

  number = Math.floor((number * 100 + 0.5) / 100).toString();

  for (var i = 0; i < Math.floor((number.length-(1 + i)) / 3); i++)
    number = number.substring(0, number.length - (4 * i + 3)) + delimiter + number.substring(number.length - (4 * i + 3));

  return format.replace('%u', unit).replace('%n', number + separator + cents);
}
