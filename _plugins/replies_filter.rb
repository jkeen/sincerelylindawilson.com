module Jekyll
  module Replies 
     def show_more(category)
       count = 0
        @context.registers[:site].posts.each do |post|
          if category == post.data['category']
            count += 1
          end         
        end
       if count > 1
         %Q{
           <a href='/topics/#{category}#response'>View Company Responses</a>
         }
       end
     end
  end
end

Liquid::Template.register_filter(Jekyll::Replies)