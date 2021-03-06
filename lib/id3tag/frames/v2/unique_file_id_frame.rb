module  ID3Tag
  module Frames
    module  V2
      class UniqueFileIdFrame < BasicFrame
        def owner_identifier
          content_split_apart_by_null_byte.first
        end

        def content
          content_split_apart_by_null_byte.last
        end

        private

        def content_split_apart_by_null_byte
          @raw_content.split("\x00", 2)
        end

        def inspect_content
          "#{owner_identifier}"
        end
      end
    end
  end
end
