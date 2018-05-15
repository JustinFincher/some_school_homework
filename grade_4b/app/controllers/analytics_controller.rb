
class AnalyticsController < ApplicationController
  def index

    logger.debug params
    if params[:begin_time].present? && params[:end_time].present?
      @tickets = Ticket.where("created_at < ?", params[:end_time]).where("created_at > ?", params[:begin_time])
      @begin_time = params[:begin_time]
      @end_time = params[:end_time]
    else
      @tickets = Ticket.all
    end

    @sum = @tickets.inject(0){|sum,x| sum + x.real_price }
  end


end