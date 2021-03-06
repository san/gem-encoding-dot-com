module EncodingDotCom
  class VideoFormat < Format #:nodoc:
    ALLOWED_OUTPUT_FORMATS = %w{flv fl9 wmv 3gp mp4 m4v ipod iphone iphone_stream ipad ipad_stream appletv psp zune mp3 wma wowza wowza_multibitrate}.freeze
    
    allowed_attributes :output, :size, :sizes, :bitrate, :framerate, :framerates, :video_codec, 
                       :audio_bitrate, :audio_sample_rate, :audio_codec, :audio_channels_number, :profile,
                       :audio_volume, :maxrate, :minrate, :bufsize, :keyframe, :keyframes, :start, :duration, 
                       :rc_init_occupancy, :crop_top, :crop_left, :crop_right, :crop_bottom,
                       :logo_source, :logo_x, :logo_y, :logo_mode, :logo_threshold, :bitrates, :file_extension,
                       :audio_sync, :segment_duration, :segmenter, :force_keyframes
    boolean_attributes :two_pass, :cbr, :hard_cbr, :deinterlacing, :add_meta, :turbo, :pack_files, :twin_turbo
    
    def initialize(attributes={})
      @attributes = attributes
      check_valid_output_format
      mixin_output_attribute_restrictions
      validate_attributes
    end

    private
    
    def check_valid_output_format
      unless ALLOWED_OUTPUT_FORMATS.include?(@attributes["output"])
        raise IllegalFormatAttribute.new("Output format #{@attributes["output"]} is not allowed.")
      end
    end
    
    def mixin_output_attribute_restrictions
      module_name = "AttributeRestrictions#{@attributes["output"].capitalize}"
      restrictions = EncodingDotCom.const_get(module_name)
      (class << self; self; end).send(:include, restrictions)
    end
    
    def validate_attributes
      validate_video_codec
      validate_size
    end

    def validate_size
    end

    def validate_video_codec
    end
  end
end
