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
         letters[category][:favorite] ||= post.data['favorite']
       end
       
       html = "<ul>"
       letters = letters.sort_by { |l| l[1][:date] }.reverse # sort by date
       
       
       html << print_letters(letters)
       
       html << "</ul>"
       html
     end
     
     def print_letters(letters)
       html = ""
       letters.each do |category, data|
         if data[:title] #only take originals
           if data[:favorite]
             html << "<li class='favorite'>"
           else
             html << "<li>"
           end
           html << %Q{<a class="box-link" href="/letters/#{category}">#{data[:title]}</a>}
           html << "<span>#{data[:count]}</span>" if data[:count] > 1
           html << "</li>"
         end
       end
       
       return html
     end
  end
end

Liquid::Template.register_tag('letter_list', Jekyll::LetterListTag)