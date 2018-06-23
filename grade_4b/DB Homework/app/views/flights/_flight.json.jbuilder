json.extract! flight, :id, :name, :number, :created_at, :updated_at
json.url flight_url(flight, format: :json)
