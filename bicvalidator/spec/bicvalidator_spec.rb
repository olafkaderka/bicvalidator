require "spec_helper"
require 'bicvalidator'

#https://relishapp.com/rspec/rspec-expectations/v/3-6/docs/built-in-matchers/be-matchers

RSpec.describe Bicvalidator do

  it "has a version number" do
    expect(Bicvalidator::VERSION).not_to be nil
  end

  it "sepa_bic_countries sind gesetzt" do 
    expect(Bicvalidator.sepa_bic_countries).not_to be nil
  end


  it "BicValidatorTest Fehler keine 8 oder 11 Zeichen" do 
    bv = Bicvalidator::Validate.new({:bic_code  => " GENODEM 1AHL123 "})
    expect(bv.bic_code).to be_nil
    expect(bv.errorcode).to eq("BV0001")
    expect(bv.sepa_country).to be false
  end

 
  it "BicValidatorTest country Lange passt nicht" do 
    bv = Bicvalidator::Validate.new({:bic_bankcode  => "1023565565", :bic_country => "DEZ"})
    expect(bv.bic_country).to be_nil
    expect(bv.errorcode).to eq("BV0002")
    expect(bv.sepa_country).to be false
  end

  it "BicValidatorTest Land AE ist nicht im Separaum (standmaessig an der test)" do 
    bv = Bicvalidator::Validate.new({:bic_code  => "GENNAEXS"})
    expect(bv.bic_code).to eq("GENNAEXSXXX")
    expect(bv.errorcode).to eq("BV0004")
    expect(bv.sepa_country).to be false
  end

  it "BicValidatorTest Land AE ohne Sepa check" do 
    bv = Bicvalidator::Validate.new({:bic_code  => "GENNAEXS", :sepa_country_check => false})
    expect(bv.bic_code).to eq("GENNAEXSXXX")
    expect(bv.errorcode).to be_nil
    expect(bv.sepa_country).to be false
  end

  it "BicValidatorTest bankcode ohne country" do 
    bv = Bicvalidator::Validate.new({:bic_bankcode  => "1023565565", :bic_country => ""})
    expect(bv.bic_country).to be_nil
    expect(bv.errorcode).to eq("BV0003")
    expect(bv.sepa_country).to be false
  end

  it "BicValidatorTest bankcode DE passnit von Leanger" do 
    bv = Bicvalidator::Validate.new({:bic_bankcode  => "1023565565", :bic_country => "DE"})
    expect(bv.errorcode).to eq("BV0010")
    expect(bv.sepa_country).to be true
  end


  it "BicValidatorTest bankcode AT passnit von Leanger" do 
    bv = Bicvalidator::Validate.new({:bic_bankcode  => "1023", :bic_country => "AT"})
    expect(bv.errorcode).to eq("BV0010")
    expect(bv.sepa_country).to be true
  end

  it "BicValidatorTest okay by bic" do 
    bv = Bicvalidator::Validate.new({:bic_code  => "GENODEM1AHL"})
    expect(bv.errorcode).to be_nil
    expect(bv.sepa_country).to be true
    expect(bv.bic_code).to eq("GENODEM1AHL")
  end



end
