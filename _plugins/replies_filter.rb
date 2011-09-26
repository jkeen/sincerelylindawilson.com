module Jekyll
  module Replies 
     def show_more(category)
       count = 0
       original_post = nil
        @context.registers[:site].posts.each do |post|
          if category == post.data['category']
            original_post = post if post.data['type'] == "original"
            count += 1
          end         
        end
       if count > 1
         text = "See what #{original_post.data['company'] || original_post.data['title']} said"
         
         %Q{
           <a class='view-response' href='/letters/#{category}#response'>#{text}</a>
         }
       end
     end
  end
end

Liquid::Template.register_filter(Jekyll::Replies)