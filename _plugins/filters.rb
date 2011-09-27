module Jekyll
  module Filters 
    def address(post)
      original_post = category_posts(post['category']).first
      who = post['company'] || original_post.data['title']
      if post['type'] == 'reply'
        "<h4 class='address'> <strong>Linda Wilson</strong> to #{who}</h4>"
      elsif post['type'] == 'response'
        "<h4 class='address'> <strong>#{who}</strong> to Linda Wilson</h4>"
      end      
    end
    
    def show_more(category)
      posts = category_posts(category)
      if posts.size > 1
        text = "See what #{posts.first.data['company'] || posts.first.data['title']} said"
        
        %Q{
          <a class='view-response' href='/letters/#{category}#response'>#{text}</a>
        }
      end
    end
    
    def editors_note(text)
      if text
        "<p class='notes'>Editors Note: #{text}</p>"
      end
    end
        
    def category_posts(category)
      posts = []
      @context.registers[:site].posts.each do |post|
        posts << post if category == post.data['category']
      end
      
      posts
    end
    
  end
end

Liquid::Template.register_filter(Jekyll::Filters)