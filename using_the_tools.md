# Using the tools

Suppose you have a fresh HTML file scraped off the old galactic-guide.com.
How can you convert it to a usable Jekyll Markdown document?

* `ArticleParser` parses the HTML and extracts the relevant data as a Ruby hash
* `JekyllArticleGenerator` consumes the hash and generates the Jekyll markdown

```ruby
  #!/usr/bin/env ruby

  require_relative 'helper_classes/article_parser'
  require_relative 'helper_classes/jekyll_article_generator'

  HTML_FILE_PATH = "recovered_content/articles/9R33.html"
  html = File.read HTML_FILE_PATH
  article =  ArticleParser.parse html
  jekyll_markdown = JekyllArticleGenerator.generate article

  File.open 'markdown.md', 'w' do |f|
    f.puts markdown
  end
```