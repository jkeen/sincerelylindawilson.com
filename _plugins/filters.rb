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
    
    def letter_list(selected_category = false)
      letters = {}
      
      @context.registers[:site].posts.each do |post| 
        category = post.data['category']
        title = post.data['title']
        type = post.data['type']
        
        letters[category] ||= {}
        letters[category][:title] = title if type == "original"
        letters[category][:count] ||= 0
        letters[category][:count] += 1
        letters[category][:favorite] ||= post.data['favorite']
        letters[category][:selected] = (category == selected_category)
      end
      
      # html = "<h3>Editor's Picks</h3>"
      # html << "<ul>"
      # favorites = letters.sort_by { |l| l[1][:date] }.reverse.select { |l| l[1][:favorite] } # sort by date
      # html << print_letters(favorites)
      # html << "</ul>"

      html = "<h3>Letters</h3>"       
      html << "<ul>"
      letters = letters.sort_by { |l| l[1][:date] }.reverse # sort by date
      html << print_letters(letters)
      html << "</ul>"
      
      html
    end
    
    def print_letters(letters)
      html = ""
      
      letters.each do |category, data|
        if data[:title] #only take originals
          classes = []
          classes << 'selected' if data[:selected]
          classes << 'favorite' if data[:favorite]
          html << "<li class='#{classes.join(" ")}'>"
          html << %Q{<a class="box-link" href="/letters/#{category}">#{data[:title]}</a>}
          html << "<span>#{data[:count]}</span>" if data[:count] > 1
          html << "</li>"
        end
      end
      
      return html
    end
    
  end
end

Liquid::Template.register_filter(Jekyll::Filters)