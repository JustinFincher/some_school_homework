class Price < ApplicationRecord
  enum seat_level: { economy: 0, business: 1 ,first_class: 2 }

  def self.seat_level_names
    @@seat_level_names
  end
  @@seat_level_names = {
      self.seat_levels[:economy]=> '经济舱',
      self.seat_levels[:business]=> '商务舱',
      self.seat_levels[:first_class]=>'头等舱'
  }
  def get_seat_level_name
    return @@seat_level_names[Price.seat_levels[self.seat_level]]
  end

  belongs_to :flight

  def self.get_or_create_price (flight_id, seat_level)
    @price = Price.where(flight_id: flight_id, seat_level: seat_level).first
    if (!@price.present?)
      logger.debug "price is not present, create one"
      @price = Price.new(flight_id: flight_id, seat_level: seat_level, price:0)
      if @price.save
        logger.debug "price saved"
      else
        logger.error @price.errors.full_messages.join("\n")
      end
    end
    return @price
  end

end
