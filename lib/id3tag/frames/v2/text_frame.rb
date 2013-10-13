module  ID3Tag
  module Frames
    module  V2
      class TextFrame < BasicFrame
        class UnsupportedTextEncoding < StandardError; end
        ENCODING_MAP = {
          0b0 => {:encoding => Encoding::ISO8859_1, :terminator => "\0"},
          0b1 => {:encoding => Encoding::UTF_16, :terminator => "\0\0"},
          0b10 => {:encoding => Encoding::UTF_16BE, :terminator => "\0\0"},
          0b11 => {:encoding => Encoding::UTF_8, :terminator => "\0"}
        }

        def content
          @content ||= StringUtil::encode_with_guess(content_without_encoding_byte, destination_encoding, source_encoding)
        end

        private

        def source_encoding
          raise(UnsupportedTextEncoding) if ENCODING_MAP[get_encoding_byte].nil?
          ENCODING_MAP[get_encoding_byte][:encoding]
        end

        def source_encoding_terminator
          raise(UnsupportedTextEncoding) if ENCODING_MAP[get_encoding_byte].nil?
          ENCODING_MAP[get_encoding_byte][:terminator]
        end

        def source_encoding_bom_guess
          raise(UnsupportedTextEncoding) if ENCODING_MAP[get_encoding_byte].nil?
          ENCODING_MAP[get_encoding_byte][:bom_guess]
        end

        def destination_encoding
          Encoding::UTF_8
        end

        def get_encoding_byte
          @raw_content.getbyte(0)
        end

        def content_without_encoding_byte
          @raw_content.byteslice(1, @raw_content.bytesize - 1)
        end
      end
    end
  end
end
