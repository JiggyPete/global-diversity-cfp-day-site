require 'yaml'

speakers = YAML.load(File.read("config/continents.yml"))["asia"]["speakers"]
speakers.each do |speaker|
  name = speaker["name"].gsub(" ", "_")
  filename = name + ".jpg"

  url =  speaker["profile_picture"]
  puts `curl #{url} > ../2021/speaker-images/images/Asia/#{filename}`
  puts ""
  puts ""
end



# `curl #{url} > ../2021/speaker-images/images/Australia-Oceania/#{filename}`
