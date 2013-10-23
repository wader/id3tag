module  ID3Tag
  module Frames
    module  V2
      class UniqueFileIdFrame < BasicFrame
        def owner_identifier
          content_split_apart_by_null_byte.first
        end

        def content(options = {})
          content_split_apart_by_null_byte.last
        end

        def inspectable_content
          "#{owner_identifier}"
        end

        private

        def content_split_apart_by_null_byte
          usable_content.split("\x00", 2)
        end
      end
    end
  end
end
