require "date"

module EncodingDotCom

  # Represents a video or image in the encoding.com queue
  class MediaListItem
    attr_reader :media_file, :media_id, :media_status, :create_date, :start_date, :finish_date, :filename

    # Creates a MediaListItem, given a <media> Nokogiri::XML::Node
    #
    # See the encoding.com documentation for GetMediaList for more details
    def initialize(node)
      @media_file = (node / "mediafile").text
      @media_id = (node / "mediaid").text.to_i
      @media_status = (node / "mediastatus").text
      @create_date = parse_time_node(node / "createdate")
      @start_date = parse_time_node(node / "startdate")
      @finish_date = parse_time_node(node / "finishdate")
      @filename = @media_file[/([^\/]+)$/]
    end

    private

    def parse_time_node(node)
      return nil if node.text=="0000-00-00 00:00:00"
      dt = DateTime.parse(node.text)
      time_elements = [dt.year, dt.month, dt.day, dt.hour, dt.min, dt.sec, nil, nil]
      Time.local *time_elements unless time_elements.all? {|e| e.nil? || e == 0 }
    end
  end
end
