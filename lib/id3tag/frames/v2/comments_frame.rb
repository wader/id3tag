module  ID3Tag
  module Frames
    module  V2
      class CommentsFrame < TextFrame

        # language code according to https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes
        def language
          @language ||= get_language
        end

        def description
          @desciption ||= encoded_description
        end

        def text
          @text ||= encoded_text
        end

        def content
          text
        end

        private

        def encoded_description
          StringUtil::encode_with_guess(raw_description, destination_encoding, source_encoding)
        end

        def encoded_text
          StringUtil::encode_with_guess(raw_text, destination_encoding, source_encoding)
        end

        def raw_description
          raw_description_and_text_parts.first
        end

        def raw_text
          raw_description_and_text_parts.last
        end

        def raw_description_and_text_parts
          @raw_text_and_content_parts ||= raw_description_and_text_parts_parse
        end

        def raw_description_and_text_parts_parse
          term = source_encoding_terminator
          bom_guess = source_encoding_bom_guess
          content = content_without_encoding_byte[3..-1]

          offset = 0
          loop do
            i = content.index(term, offset)
            # TODO: exception?
            return ["", content] if i.nil?

            # found aligned terminator
            if i % term.length == 0
              return [content[0...i], content[i+term.length..-1]]
            end

            offset += term.length
          end
        end

        def get_language
          content_without_encoding_byte[0..2].downcase
        end
      end
    end
  end
end

