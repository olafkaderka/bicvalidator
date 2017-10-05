require "bicvalidator/version"
require 'active_support'
require 'active_support/core_ext'
#brauch ich fuer laendercodes ISO3166::Country
require 'countries'

module Bicvalidator
	#mattr_accessor kommt aus active_support/core_ext'
	mattr_accessor :sepa_bic_countries

	##https://wiki.xmldation.com/Support/EPC/List_of_SEPA_countries
	#kann ich somit in einem initailizer wieder ueberschreiben
	Bicvalidator.sepa_bic_countries = ["AT", "BE", "BG", "CH", "CY", "CZ", "DE", "DK", "EE", "ES", "FI", "FR", "GB", "GR", "HR", "HU", "IE", "IT", "LI", "LT", "LU", "LV", "MC", "MT", "NL", "NO", "PL", "PT", "RO", "SE", "SI", "SK", "SM", "GI", "GF", "GP", "GG", "IS", "IM", "JE", "MQ", "YT", "RE", "BL", "MF", "PM"]


  	class Validate
  		attr_accessor :errorcode, :error_messages, :iban_str, :bic_bankcode, :bic_code, :bic_country, :sepa_country_check, :xsa_country_check, :options

	  	def initialize(options={})  
		      default_options = {
		        :bic_code => nil,
		        :bic_bankcode => nil,
		        :bic_country => nil, 
		        :sepa_country_check => true,
		        :xsa_country_check => false        
		      }
		      @options = options.reverse_merge(default_options)
		      @errorcode = nil
		      self.start_validation
	  	end

	  	def start_validation
		      #hier muss auch = "" abgefangen werden, daher check mit blank?
		      @bic_code = @options[:bic_code].blank? ? nil :  @options[:bic_code]
		      @bic_bankcode = @options[:bic_bankcode].blank? ? nil : @options[:bic_bankcode]
		      @bic_country = @options[:bic_country].blank? ? nil :  @options[:bic_country]     
		      @sepa_country_check = @options[:sepa_country_check]

		      if @bic_code
		        #strip reicht nicht denn strip entfernt nur leerzeichen vorne und hinten
		        @bic_code = @bic_code.gsub(/\s+/, "").upcase
		        #eine Bic kann nur 8 oder 11 Stellen haben
		        case @bic_code.length
		        when 8,11
		          @bic_code = "#{@bic_code}XXX" if @bic_code.length == 8 
		          #if @bic_country
		            #rein theretisch koennte man jetzt auch noch pruefen ob das ubergeben LAND uberhaupt passt
		            #aber dann muss aihc das auch erst alles bereinigen ....
		          #else
		            #@bic_country = @bic_code[4..5]
		          #end
		          @bic_country = @bic_code[4..5]
		          #ich uberschreibe einfach das Lnd mit dem BiCCODE
		        else
		          @errorcode = "BV0001"
		          return
		        end   
		      end    

		      #egal ob durch biccode gesetzt oder das land ubergeben wurde immer st checkn ob da was geht
		      if @bic_country
		        #strip reicht nicht denn strip entfernt nur leerzeichen vorne und hinten
		        @bic_country = @bic_country.gsub(/\s+/, "").upcase
		        
		        if @bic_country.length != 2
		          @bic_country = nil
		          @errorcode = "BV0002" 
		          return
		        end

		        #gibts das land uberhaupt zb wenn ZZ kommt
		        if ISO3166::Country.new("#{@bic_country}").nil?
		          @errorcode = "BV0002" 
		          return
		        end
		        if @sepa_country_check and !Bicvalidator.sepa_bic_countries.include? @bic_country
		          @errorcode = "BV0004"
		          return 
		        end

		      end

		      if @bic_bankcode
		        if !@bic_country 
		          #bankcode ohne land geht nicht
		          @errorcode = "BV0003" 
		          return
		        end
		        #strip reicht nicht denn strip entfernt nur leerzeichen vorne und hinten
		        @bic_bankcode = @bic_bankcode.gsub(/\s+/, "").upcase
		        charactersize = nil
		        #kontonummer in DE 8 stellig
		        case @bic_country
		        when "DE"
		          charactersize = 8
		        when "AT"
		          charactersize = 5
		        end
		        if charactersize and @bic_bankcode.length != charactersize
		          @errorcode = "BV0010"
		          return 
		        end
		      
		      end   


	    end

	end

end
