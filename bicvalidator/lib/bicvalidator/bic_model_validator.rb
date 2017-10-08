module Bicvalidator
  class BicModelValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      bic = Bic.new(value)
      if bic.valid?
      else
        record.errors.add attribute, bic.errorcode.to_sym
      end
    end
  end
end