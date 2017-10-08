require "spec_helper"
require 'bicvalidator'
require 'bicvalidator/bic_model_validator'

#https://relishapp.com/rspec/rspec-expectations/v/3-6/docs/built-in-matchers/be-matchers

RSpec.describe Bicvalidator do

  it "has a version number" do
    expect(Bicvalidator::VERSION).not_to be nil
  end

  it "bic_countries sind gesetzt" do 
    expect(Bicvalidator.sepa_bic_countries).not_to be nil
    expect(Bicvalidator.eu_countries).not_to be nil
  end

  class Model
      include ActiveModel::Validations
      attr_accessor :bic
      validates :bic, bic_model: true
      def initialize(bic)
        @bic = bic
      end
  end

  it 'DEUTDEFF is valid' do
      model = Model.new 'DEUTDEFF'
      model.valid?
      expect(model.errors.count).to eq(0)
    end
  
  it 'DXUTDE is invalid' do
      model = Model.new 'DXUTDE'
      model.valid?
      expect(model.errors.count).to eq(1)
      expect(model.errors.messages).to eq({:bic=>["invalid length"]})
  end

    it 'GENOÄ1AH is invalid' do
      model = Model.new 'GENOÄ1AH'
      model.valid?
      expect(model.errors.count).to eq(1)
      expect(model.errors.messages).to eq({:bic=>["invalid format"]})
  end


  it "BicValidatorTest Fehler keine 8 oder 11 Zeichen" do 
    bv = Bicvalidator::Bic.new(" GENODEM 1AHL123 ")
    expect(bv.bic_code).to eq("GENODEM1AHL123")
    expect(bv.has_valid_lenght?).to be false
    expect(bv.valid?).to be false
    expect(bv.errorcode).to eq("BV0010")
  end

  it "BicValidatorTest Formatfehler / Sonderzeichen" do 
    bv = Bicvalidator::Bic.new("GENOÄ1AH")
    expect(bv.bic_code).to eq("GENOÄ1AH")
    expect(bv.has_valid_lenght?).to be true
    expect(bv.errorcode).to eq("BV0011")
    expect(bv.valid?).to be false
    expect(bv.has_valid_format?).to be false
  end

  it "BicValidatorTest Country Code" do 
    bv = Bicvalidator::Bic.new("GENODYM1AHL")
    expect(bv.bic_code).to eq("GENODYM1AHL")
    expect(bv.valid?).to be false
    expect(bv.errorcode).to eq("BV0012")
  end


  it "BicValidatorTest Location Code 01 ungültig" do 
    bv = Bicvalidator::Bic.new("GENODE01AHL")
    expect(bv.bic_code).to eq("GENODE01AHL")
    expect(bv.valid?).to be false
    expect(bv.bank).to eq "GENO"
    expect(bv.country).to eq "DE"
    expect(bv.location).to eq "01"
    expect(bv.valid_location_code?).to be false  
    expect(bv.errorcode).to eq("BV0013")
  end

  it "BicValidatorTest Branche Code 01 ungültig, darf nicht X sein wenn XXX" do 
    bv = Bicvalidator::Bic.new("GENODEM1XHL")
    expect(bv.bic_code).to eq("GENODEM1XHL")
    expect(bv.valid?).to be false
    expect(bv.bank).to eq "GENO"
    expect(bv.country).to eq "DE"
    expect(bv.location).to eq "M1"
    expect(bv.branch).to eq "XHL"
    expect(bv.valid_branch_code?).to be false  
    expect(bv.errorcode).to eq("BV0014")
  end

  it "BicValidatorTest okay mit xxx" do 
    bv = Bicvalidator::Bic.new("GENODEM1XXX")
    expect(bv.errorcode).to be_nil
    expect(bv.bic_code).to eq("GENODEM1XXX")
    expect(bv.country).to eq("DE")
    expect(bv.sepa_scheme?).to be true
  end
 
  it "BicValidatorTest okay by bic" do 
    bv = Bicvalidator::Bic.new("GENODEM1AHL")
    expect(bv.errorcode).to be_nil
    expect(bv.bic_code).to eq("GENODEM1AHL")
    expect(bv.country).to eq("DE")
    expect(bv.location).to eq("M1")
    expect(bv.branch).to eq("AHL")
    expect(bv.eu?).to be true
    expect(bv.sepa_scheme?).to be true
  end

  it "BicValidatorTest country AE ist nicht im Separaum (standmaessig an der test)" do 
    bv = Bicvalidator::Bic.new("GENNAEXS")
    expect(bv.bic_code).to eq("GENNAEXS")
    expect(bv.bank).to eq "GENN"
    expect(bv.country).to eq "AE"
    expect(bv.location).to eq "XS"
    expect(bv.valid_location_code?).to be true   
    expect(bv.valid?).to be true    
    expect(bv.sepa_scheme?).to be false




    expect(bv.eu?).to be false
    expect(bv.non_eu?).to be true
    expect(bv.errorcode).to be_nil
  end

  it "BicValidatorTest Schweiz" do 
    bv = Bicvalidator::Bic.new("KBAGCH22")
    expect(bv.bic_code).to eq("KBAGCH22")
    expect(bv.bank).to eq "KBAG"
    expect(bv.country).to eq "CH"
    expect(bv.location).to eq "22"
    expect(bv.valid_location_code?).to be true   
    expect(bv.valid?).to be true    
    expect(bv.sepa_scheme?).to be true
    expect(bv.eu?).to be false
    expect(bv.non_eu?).to be true
    expect(bv.errorcode).to be_nil
  end




end
