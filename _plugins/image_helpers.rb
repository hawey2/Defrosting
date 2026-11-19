# frozen_string_literal: true
#
# Giúp viết bài dễ hơn:
# 1. Trong Markdown chỉ cần viết đường dẫn ảnh bắt đầu bằng /assets/...
#    Plugin tự thêm baseurl (ví dụ /Defrosting) để ảnh hiển thị đúng trên GitHub Pages.
# 2. Tự thêm loading="lazy" và decoding="async" cho mọi ảnh trong bài,
#    để trang có nhiều ảnh độ phân giải cao vẫn tải nhanh.

module Defrosting
  module ImageHelpers
    module_function

    def process(doc)
      return unless doc.output_ext == ".html" && doc.content

      base = doc.site.config["baseurl"].to_s.chomp("/")
      html = doc.content

      unless base.empty?
        html = html.gsub(/(\s(?:src|href|data-full|poster)=["'])\/(assets\/)/) { "#{Regexp.last_match(1)}#{base}/#{Regexp.last_match(2)}" }
      end

      html = html.gsub(/<img(?![^>]*\bloading=)([^>]*)>/) { "<img loading=\"lazy\" decoding=\"async\"#{Regexp.last_match(1)}>" }

      doc.content = html
    end
  end
end

Jekyll::Hooks.register [:pages, :documents], :post_convert do |doc|
  Defrosting::ImageHelpers.process(doc)
end
