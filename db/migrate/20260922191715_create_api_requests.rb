class CreateApiRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :api_requests do |t|
      t.string :query
      t.string :engine
      t.string :country
      t.integer :status_code
      t.integer :latency_ms
      t.json :response_payload

      t.timestamps
    end
  end
end
