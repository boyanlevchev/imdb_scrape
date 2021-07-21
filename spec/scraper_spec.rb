require_relative "../scraper"

# We tell our spec which method to test for - fetch fetch_movie_urls
describe "#fetch_movie_urls" do
  # The test should return red if the method does NOT return an array of a specifed number of movie urls
  # And should return freen if it does
  it "returns an array of a specifed number of movie urls" do
    urls = fetch_movie_urls(5) # actual array
    expected = [
      "https://www.imdb.com/title/tt0111161/",
      "https://www.imdb.com/title/tt0068646/",
      "https://www.imdb.com/title/tt0071562/",
      "https://www.imdb.com/title/tt0468569/",
      "https://www.imdb.com/title/tt0050083/"
    ]
    expect(urls).to eql(expected)
  end
end

# Our second test checks method - scrape_movie
describe "#scrape_movie" do
  # Red if it doesn't return a hash describing the movie
  # Green if it does
  it "returns a hash describing the movie" do
    url = "https://www.imdb.com/title/tt0468569/" # A url we are testing with
    movie = scrape_movie(url)

    # We hand-build the hash here that we know should be returned by the method
    expected = {
      cast: [ "Christian Bale", "Heath Ledger", "Aaron Eckhart" ],
      director: "Christopher Nolan",
      storyline: "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.",
      title: "The Dark Knight",
      year: 2008
    }
    # We check to make sure our hand-built hash matches the one returned by the method
    # scrape_movie when we specifically pass through "https://www.imdb.com/title/tt0468569/"
    # as the url
    expect(movie).to eql(expected)
  end
end
