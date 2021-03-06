require 'google-search'
require 'nokogiri'

# Scrape linkedin for current occupation
class HoeGaatHetMet
  def initialize(name)
    @query_name = name
    load_profile
  end

  def name
    @name ||= @profile.css('h1.fn').text
  end

  def headline
    @headline ||= @profile.css(
      'div.profile-overview-content'
    ).css('p.headline').text
  end

  def current_org
    @current_org ||= @profile.css('span.org').text
  end

  def current
    return "#{@headline} at #{@current_org}" unless @headline =~ /#{@current_org}/i
    headline
  end

  def load_profile
    company = 'nxs internet'
    query = "site:linkedin.com #{company}"
    results = Google::Search::Web.new(query: "#{query} \"#{@query_name}\"")
    puts results.pretty_inspect
    uri = results.first.uri
    if uri =~ %r{(nl|www)\.linkedin\.com/pub/dir/}
      profile_list = Nokogiri::HTML(open(uri)).css('ul.content').css('li')
      profile_select = profile_list.at('li:contains("Nxs")')
      profile_select ||= profile_list.at('li:contains("NXS")')
      profile_uri = profile_select.css('a.public-profile-link').attr('href').value
      profile = Nokogiri::HTML(open(profile_uri))
    else
      profile = Nokogiri::HTML(open(uri))
    end
    @profile = profile if profile.css('h1.fn').text =~ /#{@query_name}/i
  end
end
