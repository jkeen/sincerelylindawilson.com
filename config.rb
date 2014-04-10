###
# Blog settings
###

Time.zone = "Central Time (US & Canada)"

set :partials_dir, "_partials"

activate :blog do |blog|
  blog.name = "letters"
  # This will add a prefix to all links, template references and source paths

  blog.permalink = "/letters/{category}"
  # Matcher for blog source files
  blog.sources = "letters/:date-:title.html"
  # blog.taglink = "tags/{tag}.html"
  blog.layout = "post"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  blog.default_extension = ".markdown"

  # Enable pagination
#  blog.paginate = true
#  blog.per_page = 3
#  blog.page_link = "page/{num}"
  
  blog.custom_collections = {
    category: {
      link: '/letters/{category}.html',
      template: '/category.html'
    }
  }
end

###
# Compass
###

# Change Compass configuration
 compass_config do |config|
   config.output_style = :compact
 end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
 page "/feed.xml", layout: false
#
# With alternative layout
# page "/path/to/file.html", layout: :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }





###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
activate :livereload

activate :directory_indexes

# Methods defined in the helpers block are available in templates
helpers do
  def articles
    #noop, prevents explosion when local isn't assigned in layout
  end
  
  def current_letter(articles)
    if articles
      original_letter_from_related(articles.first)
    end
  end
  
  def page_title
    if page_articles
      original_letter_from_related(page_articles.first).data.title
    else
      current_page.data.title 
    end
  end
  
  def post_date(letter)
    (letter.data.post_date || letter.data.date).strftime("%m/%d/%y")
  end
  
  def letter_list(selected_letter = nil )
    letters = {}
    original_letters.each do |post| 
      category = post.data['category']

      letters[category] ||= {}
      letters[category][:title] = post.data['title'] if post.data['type'] == "original"
      letters[category][:count] ||= 0
      letters[category][:count] += 1
      letters[category][:favorite] ||= post.data['favorite']

      if selected_letter
        letters[category][:selected] = (category == selected_letter.data.category)
      end
    end
    
    letters.sort_by { |l| (l[1][:post_date] || l[1][:date]) }.reverse # sort by date
    
    return letters
  end
  
  def related_letters(letter)
    blog.articles.select {|a| a.data.category == letter.data.category }
  end
  
  def original_letters
    # the first letters in the 
    blog.articles.select {|a| a.data.type == 'original' && !a.data.hidden }.sort_by { |l| (l.data[:post_date] || l.data[:date]) }.reverse 
  end
  
  def original_letter_from_related(related_letter)
    related_letters(related_letter).detect { |letter| letter.data.type == 'original' }
  end

  def from_name(letter)
    if (letter.data.type == 'received') 
      respondent_name(letter)
    else
      "Linda Wilson"
    end
  end
  
  def to_name(letter)
    if (letter.data.type == 'received')
      "Linda Wilson"
    else
      respondent_name(letter)
    end
  end
  
  def previous_letter(letter)
    original = original_letter_from_related(letter)
    index = original_letters.find_index(original)
    
    if (index && index > 0) 
      return original_letters[index-1]
    else
      false
    end
  end
  
  def next_letter(letter)
    original = original_letter_from_related(letter)
    index = original_letters.find_index(original)
    
    if (index && index < original_letters.size) 
      return original_letters[index+1]
    else
      false
    end
  end

  def respondent_name(letter)
    original_post = original_letter_from_related(letter)
    original_post.data.company || original_post.data.title
  end
  
  def pagination_url(page_num)
    "/p/#{page_num}"
  end
  
  def per_page_count
    3  
  end
  
  def paged_original_letters
    original_letters.first(per_page_count)
  end
  
  def total_pages
    (original_letters.size / per_page_count).ceil
  end
  
  def current_page_num
    1 # the only time this will get seen is by the index page, which is page one. 
      # Otherwise the proxy will get it
  end
  
end

ready do
  start_index = 0 # we're only generating the second page
  page_num = 1
  letters = original_letters
  
  while start_index <= letters.size
    proxy "p/#{page_num}.html", "index.html", :locals => { 
        :paged_original_letters => letters.slice(start_index, per_page_count), 
        :current_page_num => page_num
    }
    start_index += per_page_count
    page_num += 1
  end
end

set :build_dir, 'tmp'

set :css_dir, 'css'

set :js_dir, 'js'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end
