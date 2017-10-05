# Bicvalidator

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/bicvalidator`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bicvalidator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bicvalidator

## Usage

### Sepa-Ländercodesänderung (falls gewünscht)
Man kann die standardmäßig vorgegebenen Ländercodes die zum Separaum gehören überschreiben z.b. in einem Rails initializer.
Zur Zeit wird dieser Wert standardmäßig gesetzt auf alle Länder gemäß [dieser Liste](https://wiki.xmldation.com/Support/EPC/List_of_SEPA_countries).

In den Bics sind mehr Länder als in den IBANS, denn die französischen und englischen Kolonien haben gemaess BIC einen eigenen Ländercode , in der IBAN aber nicht. 
* ["GF","GP","GG","IM","JE","MQ","YT","RE","BL","MF","PM", "PF", "TF", "NC","WF"] sind die Ländercodes der Kolonien.

* **Bicvalidator.sepa_bic_countries = []**

### Instanz Initialisierung
Das Objekt erwartet nur einen Parameter als hash in dem man die möglichen vorhanden Wert übergeben kann
* **:bic_code** String mit dem BicCode
* **:bic_bankcode** String lokale BLZ des Landes, (Land muss dann auch kommen)
* **:bic_country** String ISO 3166-1 alpha-2 (2 Stellig)
* **:sepa_country_check** true/false überprüft ob das land im Separaum ist. default => true

Alle übergeben Werte werden automatsich korrigiert falls möglich (Gross/klein, Leerzeichen entfernt)

Das Object liefert folgende attribute zurück:
* ** :errorcode, :bic_bankcode, :bic_code, :bic_country, :sepa_country_check, :options**

### Beipiele
* **bv = Bicvalidator::Validate.new({:bic_code  => " GENODEM 1A HL "})**
* bv.bic_code => "GENODEM1AHL"
* bv.bic_country => "DE"
* bv.errorcode => nil


* **bv = Bicvalidator::Validate.new({:bic_code  => "GENNAEXS"})**
* bv.bic_code => "GENNAEXS"
* bv.bic_country => "AE"
* bv.errorcode => "BV0004" (nicht im Separaum)

* **bv = Bicvalidator::Validate.new({:bic_code  => "GENNAEXS", :sepa_country_check => false})**
* bv.bic_code => "GENNAEXS"
* bv.bic_country => "AE"
* bv.errorcode => nil


### Eroorcodes
* "BV0001": BIC ungültige Länge
* "BV0002": Ungueltiges Land
* "BV0003": Bankcode ohne Land
* "BV0004": Kein SEPA Land  
* "BV0010": bic_bankcode ungültige Länge (nur bei AT/DE)


### Tests per Rspec
bundle exec rspec spec

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/olafkaderka/bicvalidator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Bicvalidator project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/olafkaderka/bicvalidator/blob/master/CODE_OF_CONDUCT.md).
