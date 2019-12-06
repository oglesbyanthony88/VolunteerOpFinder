class VolunteerMatch::Scrape

    def self.scrape_names(input)
      page = Nokogiri(open("https://www.volunteermatch.org/search/?l="+"#{input}"))
      titles = page.css("div.searchitem.PUBLIC")
      title_hash = titles.each do |section|
        volunteer_title = section.css("h3").text.gsub(/[\r\n\t\"{}]+/m, "")
        urls = section.css('a')[0]['href']
         # binding.pry
        VolunteerMatch::Opportunity.new(volunteer_title, urls)
      end
    end

    def self.scrape_info(opp_obj)
      site = "https://www.volunteermatch.org"
      page = Nokogiri(open(site + opp_obj.url))
      description = page.css("div#short_desc").css("p").text.gsub(/[\r\n\t\"{}]+/m, "")
      address = page.css("p.left").text.gsub(/[\r\n\t\"{}]+/m, "")
      foundation_info = page.css("section#tertiary-content").css("p").text.gsub(/[\r\n\t\"{}]+/m, "")
      VolunteerMatch::CLI.display_info(description, address, foundation_info)
    end

end
