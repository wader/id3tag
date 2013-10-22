module  ID3Tag
  module Frames
    module  V2
      class CommentsFrame < TextFrame

        # language code according to https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes
        def language
          @language ||= get_language
        end

        def description(options = {})
          encoded_text_and_content_parts(options).first
        end

        def text(options = {})
          cut_at_null_byte(encoded_text_and_content_parts(options).last)
        end

        def content(options = {})
          text(options)
        end

        def inspectable_content
          content
        end

        private

        def encoded_text_and_content_parts(options)
          encoded_text_and_content(options).split(NULL_BYTE)
        end

        def encoded_text_and_content(options)
          raw_text_and_content.encode(destination_encoding, options[:source_encoding] || source_encoding)
        end

        def raw_text_and_content
          content_without_encoding_byte[3..-1]
        end

        def get_language
          content_without_encoding_byte[0..2].downcase
        end
      end
    end
  end
end

