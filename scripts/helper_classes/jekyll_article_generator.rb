require 'json'

class JekyllArticleGenerator
  
  def self.generate article_data
    document = <<-EOT
---
layout:article
title: #{article_data['title']}
subtitle: #{article_data['subtitle']}
author: #{article_data['author']}
factuality: #{article_data['factuality']}
pgg_id: #{article_data['pgg_id']}
pgg_date: #{article_data['pgg_date']}
article_date: #{article_data['article_date']}
alternative_title_1: #{article_data['alternative_index_1']}
alternative_title_2: #{article_data['alternative_index_2']}
alternative_title_3: #{article_data['alternative_index_3']}
alternative_title_4: #{article_data['alternative_index_4']}
submission_string: #{article_data['submission_string']}
see_also: #{article_data['see_also']}
footnotes: #{article_data['footnotes'].to_json}
---
#{article_data['article_body']}
    EOT
  end
end