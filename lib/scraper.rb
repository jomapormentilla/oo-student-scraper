require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    flatiron = Nokogiri::HTML(open(index_url))

    students = []

    flatiron.css(".student-card").each do |card|
      hash = {
        :name => card.css(".card-text-container .student-name").text,
        :location => card.css(".card-text-container .student-location").text,
        :profile_url => card.css("a").first["href"]
      }
      
      students << hash
    end

    students
  end

  def self.scrape_profile_page(profile_url)
    flatiron = Nokogiri::HTML(open(profile_url))

    hash = {
      :profile_quote => flatiron.css(".profile-quote").text,
      :bio => flatiron.css(".description-holder p").text
    }
    
    flatiron.css(".social-icon-container a").each do |link|

      link_format = link["href"].gsub("www.","").gsub(".com","")
      link_arr = link_format.split("/")
      
      if link_arr.include?('twitter')
        hash[:twitter] = link["href"]
      elsif link_arr.include?('linkedin')
        hash[:linkedin] = link["href"]
      elsif link_arr.include?('github')
        hash[:github] = link["href"]
      elsif link_arr.include?('joemburgess')
        hash[:blog] = link["href"]
      end
    end

    hash
  end

end

