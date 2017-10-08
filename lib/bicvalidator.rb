require "bicvalidator/version"
require 'active_model'
require 'active_support'
require 'active_support/core_ext'
#brauch ich fuer laendercodes ISO3166::Country
require 'countries'

require_relative "bicvalidator/bic"
require_relative 'bicvalidator/bic_model_validator'


module Bicvalidator 
  mattr_accessor :sepa_bic_countries
  mattr_accessor :countries
  mattr_accessor :eu_countries
  #mattr_accessor :non_eu_countries
  Bicvalidator.sepa_bic_countries = ["AT", "BE", "BG", "CH", "CY", "CZ", "DE", "DK", "EE", "ES", "FI", "FR", "GB", "GR", "HR", "HU", "IE", "IT", "LI", "LT", "LU", "LV", "MC", "MT", "NL", "NO", "PL", "PT", "RO", "SE", "SI", "SK", "SM", "GI", "GF", "GP", "GG", "IS", "IM", "JE", "MQ", "YT", "RE", "BL", "MF", "PM"]
  Bicvalidator.countries = ISO3166::Country.translations.keys
  Bicvalidator.eu_countries = ISO3166::Country.all.select {|it| it.in_eu?}.map{|et| et.alpha2}


end

ActiveModel::Validations.send(:include, Bicvalidator)

I18n.load_path += Dir[File.expand_path(File.join(File.dirname(__FILE__),
  '/locales', '*.yml')).to_s]
