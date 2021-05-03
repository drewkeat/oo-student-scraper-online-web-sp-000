require_relative '../config.rb'
class Scraper

  def self.scrape_index_page(index_url)
    results = []
    html = open(index_url)
    nodes = Nokogiri::HTML(html)
    students = nodes.css(".student-card")
    students.each do |student|
      name = student.css("h4.student-name").text
      location = student.css("p.student-location").text
      url = student.css("a").attribute("href").value
      results << {
        name: name,
        location: location,
        profile_url: url
      }
    end
    results
  end
  
  def self.scrape_profile_page(profile_url)
    hash = {}
    profile = Nokogiri::HTML(open(profile_url))
    socials = profile.css("div.social-icon-container").children.css("a")
    hash[:profile_quote] = profile.css(".profile-quote").text
    hash[:bio] = profile.css("p").text
    # binding.pry
    socials.each do |social|
      case social.children.attribute("src").value
      when "../assets/img/twitter-icon.png"
        hash[:twitter] = social.attribute("href").value
      when "../assets/img/linkedin-icon.png"
        hash[:linkedin] = social.attribute("href").value
      when "../assets/img/github-icon.png"
        hash[:github] = social.attribute("href").value
      else
        hash[:blog] = social.attribute("href").value
      end
    end
    hash
  end
end

