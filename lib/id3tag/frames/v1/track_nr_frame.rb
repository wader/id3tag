module ID3Tag
  module Frames
    module V1
      class TrackNrFrame
        attr_reader :id

        def initialize(id, content)
         @id, @content = id, content
        end

        def content(options = {})
          @content.unpack(NumberUtil::FORMAT_FOR_8_BIT_SIGNED_INTEGER).first.to_s
        end
      end
    end
  end
end

