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
      attr_accessor :errorcode, :bic_bankcode, :bic_code, :bic_country, :sepa_country

      def initialize(options={})  
          default_options = {
            :bic_code => nil,
            :bic_bankcode => nil,
            :bic_country => nil, 
            :sepa_country_check => true,
          }
          @options = options.reverse_merge(default_options)


          @errorcode = nil
          @sepa_country = false
          self.start_validation
      end

      def start_validation
          #hier muss auch = "" abgefangen werden, daher check mit blank?
          @bic_code = @options[:bic_code].blank? ? nil :  @options[:bic_code]
          @bic_bankcode = @options[:bic_bankcode].blank? ? nil : @options[:bic_bankcode]
          @bic_country = @options[:bic_country].blank? ? nil :  @options[:bic_country]     
         

          if [@bic_code,@bic_bankcode,@bic_country].all? {|x| x.nil?}
            @errorcode = "BV0000"
            return
          end

          @sepa_country_check = @options[:sepa_country_check]

          if @bic_code
            #strip reicht nicht denn strip entfernt nur leerzeichen vorne und hinten
            @bic_code = self.canonicalize_str(@bic_code)

                          #invalid character     
            if (@bic_code =~ /^[A-Z0-9]+$/).nil?
              @bic_code = nil
              @errorcode = "BV0010"
              return 
            end

            #muss 8 oder 11 stellen haben
            case @bic_code.length
            when 8
              #wir furllen immer mit XXX auf 11 Stellen auf 
              @bic_code = "#{@bic_code}XXX"
            when 11
              
            else
              @bic_code = nil
              @errorcode = "BV0011"
              return
            end
            #wir setzen bic_country auf die 4+5 Stelle des der BIC
            @bic_country = @bic_code[4..5]

          end    

          #egal ob durch biccode gesetzt oder das land ubergeben wurde immer st checkn ob da was geht
          if @bic_country
            #strip reicht nicht denn strip entfernt nur leerzeichen vorne und hinten
            @bic_country = self.canonicalize_str(@bic_country)

            if @bic_country.length != 2
              @bic_country = nil
              @errorcode = "BV0020" 
              return
            end
            if (@bic_country =~ /^[A-Z]+$/).nil?
              @bic_country = nil
              @errorcode = "BV0021"
              return 
            end

            #gibts das land uberhaupt zb wenn ZZ kommt
            if ISO3166::Country.new("#{@bic_country}").nil?
              @bic_country = nil
              @errorcode = "BV0025" 
              return
            end

            if Bicvalidator.sepa_bic_countries.include? @bic_country
              @sepa_country = true
            end

            if @sepa_country_check and !@sepa_country
              @errorcode = "BV0026"
              return 
            end

          end

          if @bic_bankcode
            
            if !@bic_country 
              #bankcode ohne land geht nicht
              @errorcode = "BV0030" 
              return
            end
           
            #strip reicht nicht denn strip entfernt nur leerzeichen vorne und hinten
            @bic_bankcode = self.canonicalize_str(@bic_bankcode)

            #es duerfen nur A-Z und 0-9 kommne, keine Sonderzeichen
            if (@bic_bankcode =~ /^[A-Z0-9]+$/).nil?
              @bic_bankcode = nil
              @errorcode = "BV0032"
              return 
            end

            return if !["DE","AT"].include? @bic_country
            #kontonummer in DE 8 stellig
            case @bic_country
            when "DE"
              #kontonummer in DE 8 stellig Zahlen
              rule = '^[0-9]{8}$'
            when "AT"
              #kontonummer in AT 5 stellig Zahlen
              rule = '^[0-9]{5}$'
            end

            if regexp = Regexp.new(rule).match(@bic_bankcode)
              #hat er gefunden
            else
              @bic_bankcode = nil
              @errorcode = "BV0040"
              return
            end
          
          end   


      end



      def canonicalize_str(str)
        str.strip.gsub(/\s+/, '').upcase
      end

    end

end
