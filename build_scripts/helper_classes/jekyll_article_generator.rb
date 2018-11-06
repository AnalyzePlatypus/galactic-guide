require 'yaml'

class JekyllArticleGenerator
  
  def self.generate article_data
    document = <<-EOT
---
layout: "article"
title: "#{article_data["title"]}"
subtitle: "#{article_data["subtitle"]}"
author: "#{article_data["author"]}"
factuality: "#{article_data["factuality"]}"
pgg_id: "#{article_data["pgg_id"]}"
permalink: "articles/#{article_data["pgg_id"]}"
pgg_date: "#{article_data["pgg_date"]}"
article_date: "#{article_data["article_date"]}"
alternative_title_1: "#{article_data["alternative_index_1"]}"
alternative_title_2: "#{article_data["alternative_index_2"]}"
alternative_title_3: "#{article_data["alternative_index_3"]}"
alternative_title_4: "#{article_data["alternative_index_4"]}"
submission_string: "#{article_data["submission_string"]}"
see_also:\n#{array_to_yaml article_data["see_also"] || []}
footnotes: \n#{hash_to_yaml article_data["footnotes"] || {}}
---
#{article_data["article_body"]}
EOT
  end


end

def array_to_yaml array
  array.map {|item| "  - #{item}"}.join("\n")
end

def hash_to_yaml hash
  yaml = ""
  hash.each do |k,v|
    yaml += "  - #{k}:\n    number: #{k}\n    text: \"#{v}\"\n"
  end
  yaml
end

