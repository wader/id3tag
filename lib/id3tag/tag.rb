module ID3Tag
  class Tag
    class MultipleFrameError < StandardError; end

    class << self
      def read(source, version = :all)
        new(source, version)
      end
    end

    def initialize(source, version = :all)
      @source, @version = source, version
    end

    def artist(options = {})
      get_frame_content([[:v2, :artist], [:v1, :artist]], options)
    end

    def title(options = {})
      get_frame_content([[:v2, :title], [:v1, :title]], options)
    end

    def album(options = {})
      get_frame_content([[:v2, :album], [:v1, :album]], options)
    end

    def year(options = {})
      get_frame_content([[:v2, :year], [:v1, :year]], options)
    end

    def track_nr(options = {})
      get_frame_content([[:v2, :track_nr], [:v1, :track_nr]], options)
    end

    def genre(options = {})
      get_frame_content([[:v2, :genre], [:v1, :genre]], options)
    end

    def comments(options = {})
      get_frame_content([[:v2, :comments], [:v1, :comments]], options)
    end

    def unsychronized_transcription(options = {})
      get_frame_content([[:v2, :unsychronized_transcription]], options)
    end

    def get_frame(frame_id)
      frames = get_frames(frame_id)
      if frames.count > 1
        raise MultipleFrameError, "Could not return only one frame with id: #{frame_id}. Tag has #{frames.count} of them"
      else
        frames.first
      end
    end

    def get_frames(frame_id)
      frames.select { |frame| frame.id == frame_id }
    end

    def frame_ids
      frames.map { |frame| frame.id }
    end

    def frames
      @frames ||= v2_frames + v1_frames
    end

    def v2_frames
      if audio_file.v2_tag_present? && [:v2, :all].include?(@version)
        ID3V2FrameParser.new(audio_file.v2_tag_body, audio_file.v2_tag_major_version_number).frames
      else
        []
      end
    end

    def v1_frames
      if audio_file.v1_tag_present? && [:v1, :all].include?(@version)
        ID3V1FrameParser.new(audio_file.v1_tag_body).frames
      else
        []
      end
    end

    def get_frame_content(frame_ver_names, options)
      frame = nil
      frame_ver_names.each do |ver, name|
        frame = get_frame(frame_id(ver, name))
        break if frame
      end
      frame && frame.content(options)
    end

    private

    def frame_id(version, name)
      case version
      when :v2
        if audio_file.v2_tag_present?
          FrameIdAdvisor.new(2, audio_file.v2_tag_major_version_number).advise(name)
        end
      when :v1
        FrameIdAdvisor.new(1, 'x').advise(name)
      else
        nil
      end
    end

    def audio_file
      @audio_file ||= AudioFile.new(@source)
    end
  end
end
