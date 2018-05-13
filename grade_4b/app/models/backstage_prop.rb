class BackstageProp < ApplicationRecord

  serialize :plane_types, Array

  def self.get_the_only_prop
    if BackstageProp.any?
      return BackstageProp.first
    else
      @backstage_prop = BackstageProp.new
      @backstage_prop.save
      return @backstage_prop
    end
  end

end
