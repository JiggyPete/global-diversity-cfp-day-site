class Continents
  def self.all
    YAML.load_file("#{Rails.root.to_s}/config/continents.yml")
  end

  def self.get(continent)
    all[continent]
  end
end
