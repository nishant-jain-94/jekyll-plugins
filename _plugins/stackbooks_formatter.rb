require "nokogiri"
module Stackbooks
  def stackbooks_video_formatter(input)
    # puts input
    document = Nokogiri::HTML.parse(input)
    body_element = document.xpath('//body').first
    document.css('//video[data-type="ams"]').each do |video_element|
      source = video_element.get_attribute('data-src')
      video_element.set_attribute('controls', 'true')
      video_element.remove_attribute('data-src')
      video_element.remove_attribute('src')
      video_element.inner_html = document.create_element "source", :src => source, :type => "application/dash+xml"
    end
    document.css('//video').each_with_index do |video_element, index|
      video_element.set_attribute("class", "video-js")
      video_element.set_attribute("id", "video_#{index}")
    end
    document.xpath('//body/*').to_s
  end

  def stackbooks_video_initializer(input)
    document = Nokogiri::HTML.parse(input)
    script_element = document.create_element "script"
    document.css('//video').each_with_index do |video_element, index|
      video_element.set_attribute("id", "video_#{index}")
      script_element.inner_html += "var player_#{index} = videojs('#{video_element.get_attribute("id")}');"
    end
    script_element.to_s
  end
end

Liquid::Template.register_filter(Stackbooks)
