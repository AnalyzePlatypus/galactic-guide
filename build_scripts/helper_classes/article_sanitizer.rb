class ArticleSanitizer
  def self.sanitize nokogiri_elem
    [:cleanup_article, 
     :cleanup_ol, 
     :configure_footnote_links, 
     :cleanup_heading_anchors
    ].each do |method_sym|
      method = self.method method_sym
      method.call nokogiri_elem
    end
    nokogiri_elem
  end

  private

  # Remove some noisy markup from the article wrapper <div>
  def self.cleanup_article nokogiri_article_object
    nokogiri_article_object.css(".c5").remove_class "c5"
  end

  # Strip some noisy markup from any <ol> lists that may be present
  def self.cleanup_ol nokogiri_elem
    ol_elems = nokogiri_elem.css("ol")
    ol_elems.remove_attr "type" unless ol_elems.nil?
    nokogiri_elem
  end

  # Add the links that power jumping to the footnotes
  def self.configure_footnote_links nokogiri_elem
    hash_link_elems = nokogiri_elem.css "a[href^='#']"

    hash_link_elems.each do |link_elem|
      footnote_number = remove_brackets(link_elem.text)

      corresponding_footnote_url = "#footnote-body.#{footnote_number}" # This points to the anchor in the corresponding footnote. (The footnote generates the landing anchor for this link indepenently, in the 'article' layout)
      self_url = "footnote-link.#{footnote_number}" # This will be pointed to by the footnote itself

      link_elem["href"] = corresponding_footnote_url
      link_elem["name"] = self_url
      
      link_elem.add_class "footnote-link"
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

  def self.remove_brackets str
    str.gsub /\[|\]/, ""
  end
end
