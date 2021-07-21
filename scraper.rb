require 'open-uri'
require 'nokogiri'

def fetch_movie_urls(count) # Our fetch movies method accepts a user inputted value to choose how many movies to retrieve
  # We c
  movies = []
  url = "https://www.imdb.com/chart/top/?ref_=nv_mv_250"
  # we open the url with open-uri
  website = URI.open(url).read

  # Then we parse it into an object that we can run queries on
  html_doc = Nokogiri::HTML(website)

  # We look for the class .titleColumn, which represents a card of each movie
  # Within each of these cards we know we will be able to find the url that leads
  # To the movie's specific page
  html_doc.search('.titleColumn').take(count).each do |element|
    # We grab the second child of the element, and capture its href attribute, which holds the relative url
    # To the movie's page - and then we interpolate into a full, absolute url
    movies << "https://www.imdb.com#{element.children[1].attribute("href").value}"
  end
  movies
end

def scrape_movie(url)
  #  we start with an empty movie hash - as we know this is what the method needs to return
  movie = {}

  # we open the url with open-uri
  website = URI.open(url).read

  # Then we parse it into an object that we can run queries on
  html_doc = Nokogiri::HTML(website)

  # NOTE:
  # For each of these searches - we have to inspect the webpage to see what is the appropriate class
  # There is a lot of trial and error - as it's hard to discern if a certain class is used more than once
  # If it is, you might have to respecify your search for clearer results

  # Title was reasonably straightforward - it has a unique styling and is a unique element (there is just one title)
  # so we just use the class directly asociated with the heading element
  # We use .first as the search method returns an array (of 1 element)
  title = html_doc.search('.TitleHeader__TitleText-sc-1wu6n3d-0').first.text

  # This we finished during live code - a bit harder to do than the title
  # As there are a few elements that have the same class as the element that holds the director's name
  # So instead we find something unique nearby - such as the element that contains the exact words "Director"
  # And then from there specify that we want an a tag within
  # The contains modifier is provided by JQuery - and can be used on a parent that contains the word Director somewhere
  # Down the chain i.e. one of its children contains the word director
  director = html_doc.search('.ipc-metadata-list__item:contains("Director") a').first.text

  # This one ended up being quite complicated, as the page had a hidden element called Stars as well
  # So first we search for the items containing the word Stars, ignore then second one
  # And in the first one, perform a second search that matches the search we did when looking for director
  # Capturing the a tag, and getting the text from within it
  cast = []
  html_doc.search('.ipc-metadata-list__item:contains("Stars")').first.search('.ipc-inline-list a').each do |element|
    cast << element.text
  end

  # This one is unique, so easy to access
  storyline = html_doc.search('.GenresAndPlot__TextContainerBreakpointXL-cum89p-2').first.text

  # This one is a bit less unique, so we make the executive decision to assume
  # That IMDB will always display the year before the age rating (PG13/ 12A)
  # And so just say use the first element that appears with the given class
  year = html_doc.search('.ipc-inline-list--show-dividers.TitleBlockMetaData__MetaDataList-sc-12ein40-0 a').first.text.to_i

  {
    title: title,
    director: director,
    cast: cast,
    storyline: storyline,
    year: year

  }
end
