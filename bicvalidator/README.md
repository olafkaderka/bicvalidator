# Bicvalidator
Mit dem BicValidator wird eine BIC gemäß den [ISO9362)(https://de.wikipedia.org/wiki/ISO_9362) Anforderungen geprüft. Zusätzlich wird übeprüft ob die BIC gemäß dem Ländercode im SEPA Raum ist.

Inspiriert von [boostify/bic_validation](https://github.com/boostify/bic_validation)

## Installation

Das muss ins Gemfile:

```ruby
gem 'bicvalidator'
```

Und dann ausführen:

    $ bundle

## Usage

### Sepa-Ländercodesänderung (falls gewünscht)
Man kann die standardmäßig vorgegebenen Ländercodes die zum Separaum gehören überschreiben z.b. in einem Rails initializer.
Zur Zeit wird dieser Wert standardmäßig gesetzt auf alle Länder gemäß [dieser Liste](https://wiki.xmldation.com/Support/EPC/List_of_SEPA_countries).

In den Bics sind mehr Länder als in den IBANS, denn die französischen und englischen Kolonien haben gemaess BIC einen eigenen Ländercode , in der IBAN aber nicht. 
* ["GF","GP","GG","IM","JE","MQ","YT","RE","BL","MF","PM", "PF", "TF", "NC","WF"] sind die Ländercodes der Kolonien.

* **Bicvalidator.sepa_bic_countries = []**

### Instanz Initialisierung
**Bicvalidator::Bic.new(string)**

### Beipiele
**bv = Bicvalidator::Bic.new(" GENODEM 1A HL ")**
   
    bv.errorcode => nil
    bv.bic_code => GENODEM1AHL"
    bv.country => "DE"
    bv.location) => "M1"
    bv.branch) => "AHL"
    bv.sepa_scheme? => true (ist gemäß dem SEPA-Ländercodes im SEPA-Schema Raum)


### Errorcodes
Wen man genau wissen will , was der Fehler ist kann man mit bv.errorcode den genauen Wert ermitteln
"BV0010" if !has_valid_lenght?
"BV0011" if !has_valid_format?
"BV0012" if !valid_country_code?
"BV0013" if !valid_location_code?
"BV0014" if !valid_branch_code?

### Tests per Rspec
rspec

### Gem Pushing
gem build bicvalidator.gemspec
gem push bicvalidator-X.X.X.gem

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. 

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/olafkaderka/bicvalidator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

