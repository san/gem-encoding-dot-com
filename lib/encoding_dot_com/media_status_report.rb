require "date"

module EncodingDotCom

  # Represents the full status response of a video or image in the encoding.com queue
  class MediaStatusReport
    attr_reader :source_file, :media_id, :status, :created, :started, :finished, :downloaded,
                :file_size, :processor, :time_left, :progress, :notify_url

    # Creates a MediaListItem, given a <media> Nokogiri::XML::Node
    #
    # See the encoding.com documentation for GetMediaList for more details
    def initialize(node)
      @source_file = (node / "sourcefile").text
      @media_id = (node / "id").text.to_i
      @status = (node / "status").first.text
      @processor = (node / "processor").text
      @time_left = (node / "time_left").text.to_i
      @progress = (node / "progress").text.to_i
      @file_size = (node / "filesize").text.to_i
      @notify_url = (node / "notifyurl").text

      # Different xpath to handle multiple created nodes in document (e.g. in format sections)
      @created = parse_time_node(node.xpath(node / 'created'))
      @started = parse_time_node(node.xpath(node / 'started'))
      @finished = parse_time_node(node.xpath(node / 'finished'))
      @downloaded = parse_time_node(node.xpath(node / 'downloaded'))
    end

    private

    def parse_time_node(node)
      node = node.is_a?(Array) ? node.first : node
      return nil if node.text=="0000-00-00 00:00:00"
      dt = DateTime.parse(node.text)
      time_elements = [dt.year, dt.month, dt.day, dt.hour, dt.min, dt.sec, nil, nil]
      Time.local *time_elements unless time_elements.all? {|e| e.nil? || e == 0 }
    end
  end
end
