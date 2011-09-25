module Jekyll
  class LetterListTag < Liquid::Tag
     def render(context)
       letters = {}
       
       context.registers[:site].posts.each do |post| 
         category = post.data['category']
         title = post.data['title']
         type = post.data['type']
         
         letters[category] ||= {}
         letters[category][:title] = title if type == "original"
         letters[category][:count] ||= 0
         letters[category][:count] += 1
         letters[category][:date] = post.data['date']
       end
       
       html = "<ul>"
       letters = letters.sort_by { |l| l[1][:date] }.reverse # sort by date
       letters.each do |category, data|
         if data[:title] #only take originals
           html << "<li>"
           html << %Q{<a href="/topics/#{category}">#{data[:title]}</a>}
           html << "<span>#{data[:count]}</span>" if data[:count] > 1
           html << "</li>"
         end
       end
       html << "</ul>"
       html
     end
  end
end

Liquid::Template.register_tag('letter_list', Jekyll::LetterListTag)