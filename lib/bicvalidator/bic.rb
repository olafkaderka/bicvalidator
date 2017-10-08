module Bicvalidator
    class Bic
      attr_accessor :bic_code, :bank, :country, :location, :branch
      def initialize(bic_str) 
          ##strip reicht nicht denn strip entfernt nur leerzeichen vorne und hinten
          @bic_code = bic_str.strip.gsub(/\s+/, '').upcase
      end
      def errorcode
        return if valid?
        return "BV0010" if !has_valid_lenght?
        return "BV0011" if !has_valid_format?
        return "BV0012" if !valid_country_code?
        return "BV0013" if !valid_location_code?
        return "BV0014" if !valid_branch_code?
      end
      #in instanz
      def valid?
        has_valid_lenght? && has_valid_format? && valid_country_code? && valid_location_code? && valid_branch_code?
      end

      def has_valid_lenght?
         [8, 11].include? @bic_code.length     
      end

      def has_valid_format?
        !(@bic_code =~ bic_iso_format).nil?
      end

      def valid_country_code?
        Bicvalidator.countries.include? country
      end

      def valid_location_code?
        #http://de.wikipedia.org/wiki/ISO_9362
        #2-stellige Codierung des Ortes in zwei Zeichen. Das erste Zeichen darf nicht die Ziffer „0“ oder „1“ sein.
        #Der Buchstabe 'O' ist als zweites Zeichen nicht gestattet.
        !(location[0] =~ /[^01]/ && location[1] =~ /[^O]/).nil?
      end

      def valid_branch_code?
        #Der Branch-Code darf nicht mit „X“ anfangen, es sei denn, es ist „XXX“.
        return true if @bic_code.length == 8
        return true if branch == "XXX"
        (branch[0] =~ /[X]/).nil?          
      end

      def eu?
        @eu ||= (valid? and Bicvalidator.eu_countries.include? country)
      end

      def non_eu?
        @non_eu ||= (valid? and !eu?)
      end

      def sepa_scheme?
        #es koennen auch laender am SEAP teilnhmen die nicht in de rEU sind, wie zb CH
        valid? and Bicvalidator.sepa_bic_countries.include? country
      end


      def bank
        @bank ||= match[1]
      end

      def country
        @country ||= match[2]
      end

      def location
        @location ||= match[3]
      end

      def branch
        @branch ||= match[4]
      end

      private

      def bic_iso_format
        #https://de.wikipedia.org/wiki/ISO_9362
        #BBBB 4-stelliger Bankcode, vom Geldinstitut frei wählbar
        #CC 2-stelliger Ländercode nach ISO 3166-1
        #LL 2-stellige Codierung des Ortes in zwei Zeichen. 
          #Das erste Zeichen darf nicht die Ziffer „0“ oder „1“ sein. 
          #Wenn das zweite Zeichen kein Buchstabe, sondern eine Ziffer ist, so bedeutet dies:
        #bbb 3-stellige Kennzeichnung (Branch-Code) der Filiale oder Abteilung (optional)
        #test in http://rubular.com/
        /([A-Z]{4})([A-Z]{2})([0-9A-Z]{2})([0-9A-Z]{3})?/
      end

      def match
        bic_iso_format.match(@bic_code)
      end


    end
end