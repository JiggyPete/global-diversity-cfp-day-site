require 'yaml'
require 'erb'

def build_url(continent, speaker)
  # puts continent
  # puts speaker
  profile_picture = speaker["profile_picture"]
  if profile_picture.start_with?("/images")
    profile_picture = "https://www.globaldiversitycfpday.com" + profile_picture
  end

  twitter = "#{speaker["pronouns"]} @#{speaker["twitter"]}".strip
  base_url = "https://jiggypete.github.io/speaker-promo"
  # base_url = "http://localhost:5000"
  url = "#{base_url}/?name=#{speaker["name"]}&twitter=#{twitter}&talk=#{speaker["talk_title"]}&continent=#{continent}&picture-url=#{profile_picture}"
  puts `open "#{url}"`
end

yml = YAML.load(File.read("config/continents.yml"))

continent_data = [
  yml["australia_and_oceania"]
  # yml["asia"]
  # yml["africa"]
  # yml["europe"]
  # yml["north_america"]
  # yml["south_america"]
]

continent_data.each do |continent|
  puts ""
  puts ""
  continent_name = continent["name"]
  continent["speakers"].each do |speaker|
    build_url continent_name, speaker
  end
end
