class Cfp < ApplicationRecord

  validates_presence_of :continent, :country, :city, :conference_name, :website, :cfp_url, :twitter_handle, :cfp_close_date

  def self.cfps_grouped_for_homepage
    result = Cfp.all.order(:continent, :country, :city).group_by(&:continent)

    result.keys.each do |continent|
      result[continent] = result[continent].group_by(&:country)
    end

    result
  end

end
