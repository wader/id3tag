module ID3Tag
  module StringUtil
    BOM_GUESS_MAP = {
      Encoding::UTF_16 => "\xff\xfe",
      Encoding::UTF_16BE => "\xfe\xff"
    }

    def self.blank?(string)
      string !~ /[^[:space:]]/
    end

    def self.do_unsynchronization(input)
      unsynch = Unsynchronization.new(input)
      unsynch.apply
      unsynch.output
    end

    def self.undo_unsynchronization(input)
      unsynch = Unsynchronization.new(input)
      unsynch.remove
      unsynch.output
    end

    def self.encode_with_guess(string, dst_encoding, src_encoding)
      begin
        string.encode(dst_encoding, src_encoding)
      rescue Encoding::InvalidByteSequenceError => e
        raise e if BOM_GUESS_MAP[src_encoding].nil?
        (BOM_GUESS_MAP[src_encoding] + string).encode(dst_encoding, src_encoding)
      end
    end
  end
end
