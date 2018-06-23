json.extract! ticket, :id, :price, :user_id, :flight_id, :created_at, :updated_at
json.url ticket_url(ticket, format: :json)
