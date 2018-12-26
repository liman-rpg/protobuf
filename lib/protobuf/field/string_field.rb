require 'protobuf/field/bytes_field'

module Protobuf
  module Field
    class StringField < BytesField

      ##
      # Constants
      #

      ENCODING = Encoding::UTF_8

      ##
      # Public Instance Methods
      #

      def acceptable?(val)
        val.is_a?(String) || val.nil? || val.is_a?(Symbol)
      end

      def coerce!(value)
        if value.nil?
          nil
        else
          value.to_s
        end
      end

      def decode(bytes)
        bytes_to_decode = "" + bytes
        bytes_to_decode.force_encoding(::Protobuf::Field::StringField::ENCODING)
        bytes_to_decode
      end

      def encode(value)
        value_to_encode = "" + value # dup is slower
        unless value_to_encode.encoding == ENCODING
          value_to_encode.encode!(::Protobuf::Field::StringField::ENCODING, :invalid => :replace, :undef => :replace, :replace => "")
        end
        value_to_encode.force_encoding(::Protobuf::Field::BytesField::BYTES_ENCODING)

        "#{::Protobuf::Field::VarintField.encode(value_to_encode.size)}#{value_to_encode}"
      end

      def encode_to_stream(value, stream)
        new_value = "" + value
        if new_value.encoding != ::Protobuf::Field::StringField::ENCODING
          new_value.encode!(::Protobuf::Field::StringField::ENCODING, :invalid => :replace, :undef => :replace, :replace => "")
        end

        stream << tag_encoded << ::Protobuf::Field::VarintField.encode(new_value.bytesize) << new_value
      end

      def json_encode(value)
        value
      end
    end
  end
end
