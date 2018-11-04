class ArticleSanitizer
  def self.sanitize nokogiri_elem
    [:cleanup_article, :cleanup_ol, :cleanup_footnote_links, :cleanup_heading_anchors].each do |method_sym|
      method = self.method method_sym
      method.call nokogiri_elem
    end
    nokogiri_elem
  end

  private

  def self.cleanup_article nokogiri_article_object
    nokogiri_article_object.css(".c5").remove_class "c5"
    cleanup_ol nokogiri_article_object
    cleanup_footnote_links nokogiri_article_object
    nokogiri_article_object
  end

  def self.cleanup_ol nokogiri_elem
    ol_elems = nokogiri_elem.css("ol")
    ol_elems.remove_attr "type" unless ol_elems.nil?
    nokogiri_elem
  end

  def self.cleanup_footnote_links nokogiri_elem
    hash_link_elems = nokogiri_elem.css "a[href^='#']"
    hash_link_elems.remove_attr "name"
    hash_link_elems.add_class "footnote-link"
    hash_link_elems.each do |link_elem|
      footnote_number = link_elem.text.gsub /\[|\]/, ""
      link_url = "#footnotes.#{footnote_number}"
      link_elem["href"] = link_url
    end
    nokogiri_elem
  end

  # Remove the <a> element from h2 elems in the article
  #   From: <h2><a> Hey, I'm a title </a><h2>
  #   To:   <h2>    Hey, I'm a title     </h2>
  def self.cleanup_heading_anchors nokogiri_elem
    headings = nokogiri_elem.css "h2"
    headings += nokogiri_elem.css "h3"
    headings.each do |heading_elem|
      next unless heading_elem.css "a"
      heading_text = heading_elem.text
      heading_a_elem = heading_elem.css "a[name]"
      heading_a_elem.unlink
      heading_elem.inner_html = heading_text
    end
    nokogiri_elem
  end

end