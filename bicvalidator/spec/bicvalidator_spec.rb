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


  it "BicValidatorTest keine werte" do 
    bv = Bicvalidator::Validate.new()
    expect(bv.bic_code).to be_nil
    expect(bv.sepa_country).to be false
    expect(bv.errorcode).to eq("BV0000")
  end

  it "BicValidatorTest ungültige Zeichen" do 
    bv = Bicvalidator::Validate.new({:bic_code  => " GENODEÄ 1AHL123 "})
    expect(bv.bic_code).to be_nil
    expect(bv.sepa_country).to be false
    expect(bv.errorcode).to eq("BV0010")
  end

  it "BicValidatorTest Fehler keine 8 oder 11 Zeichen" do 
    bv = Bicvalidator::Validate.new({:bic_code  => " GENODEM 1AHL123 "})
    expect(bv.bic_code).to be_nil
    expect(bv.errorcode).to eq("BV0011")
    expect(bv.sepa_country).to be false
  end

 
  it "BicValidatorTest country Lange passt nicht" do 
    bv = Bicvalidator::Validate.new({:bic_bankcode  => "1023565565", :bic_country => "DEZ"})
    expect(bv.bic_country).to be_nil
    expect(bv.errorcode).to eq("BV0020")
    expect(bv.sepa_country).to be false
  end

  it "BicValidatorTest country ungueltige zeichen" do 
    bv = Bicvalidator::Validate.new({:bic_bankcode  => "1023565565", :bic_country => "Dä"})
    expect(bv.bic_country).to be_nil
    expect(bv.errorcode).to eq("BV0021")
    expect(bv.sepa_country).to be false
  end


  it "BicValidatorTest country unbekannt" do 
    bv = Bicvalidator::Validate.new({:bic_bankcode  => "1023565565", :bic_country => "ZZ"})
    expect(bv.bic_country).to be_nil
    expect(bv.errorcode).to eq("BV0025")
    expect(bv.sepa_country).to be false
  end


  it "BicValidatorTest country AE ist nicht im Separaum (standmaessig an der test)" do 
    bv = Bicvalidator::Validate.new({:bic_code  => "GENNAEXS"})
    expect(bv.bic_code).to eq("GENNAEXSXXX")
    expect(bv.errorcode).to eq("BV0026")
    expect(bv.sepa_country).to be false
  end

  it "BicValidatorTest bankcode ohne country" do 
    bv = Bicvalidator::Validate.new({:bic_bankcode  => "1023565565", :bic_country => ""})
    expect(bv.bic_country).to be_nil
    expect(bv.errorcode).to eq("BV0030")
    expect(bv.sepa_country).to be false
  end


  it "BicValidatorTest bankcode un gueltige zeichen" do 
    bv = Bicvalidator::Validate.new({:bic_bankcode  => "102Ä565565", :bic_country => "DE"})
    expect(bv.bic_country).to eq("DE")
    expect(bv.bic_bankcode).to be_nil
    expect(bv.errorcode).to eq("BV0032")
    expect(bv.sepa_country).to be true
  end

  it "BicValidatorTest bankcode DE ungueltige Zeichen" do 
    bv = Bicvalidator::Validate.new({:bic_bankcode  => "10A3565565", :bic_country => "DE"})
    expect(bv.errorcode).to eq("BV0040")
    expect(bv.sepa_country).to be true
  end


  it "BicValidatorTest bankcode DE passt nicht von Leanger" do 
    bv = Bicvalidator::Validate.new({:bic_bankcode  => "1023565565", :bic_country => "DE"})
    expect(bv.errorcode).to eq("BV0040")
    expect(bv.sepa_country).to be true
  end


  it "BicValidatorTest bankcode AT ungueltige Zeichen" do 
    bv = Bicvalidator::Validate.new({:bic_bankcode  => "10A56", :bic_country => "AT"})
    expect(bv.errorcode).to eq("BV0040")
    expect(bv.sepa_country).to be true
  end

  it "BicValidatorTest bankcode AT passnit von Leanger" do 
    bv = Bicvalidator::Validate.new({:bic_bankcode  => "1023", :bic_country => "AT"})
    expect(bv.errorcode).to eq("BV0040")
    expect(bv.sepa_country).to be true
  end

  #abe rhier ales okay

  it "BicValidatorTest Land AE ohne Sepa check alle skay" do 
    bv = Bicvalidator::Validate.new({:bic_code  => "GENNAEXS", :sepa_country_check => false})
    expect(bv.bic_code).to eq("GENNAEXSXXX")
    expect(bv.errorcode).to be_nil
    expect(bv.sepa_country).to be false
  end


  it "BicValidatorTest okay by bic" do 
    bv = Bicvalidator::Validate.new({:bic_code  => "GENODEM1AHL"})
    expect(bv.errorcode).to be_nil
    expect(bv.sepa_country).to be true
    expect(bv.bic_code).to eq("GENODEM1AHL")
  end



end
