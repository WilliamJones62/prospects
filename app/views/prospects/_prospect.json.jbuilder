json.extract! prospect, :id, :customer_id, :name, :calls, :first_call, :last_call, :credit_terms, :created_at, :updated_at
json.url prospect_url(prospect, format: :json)
