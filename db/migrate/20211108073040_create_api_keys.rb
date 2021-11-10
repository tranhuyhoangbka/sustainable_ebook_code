class CreateApiKeys < ActiveRecord::Migration[6.1]
  def change
    create_table :api_keys, comment: "Holds all api keys for access to api" do |t|
      t.text :key, null: false, comment: "the actual key"
      t.text :client_name, null: false
      t.datetime :deactived_at, null: true

      t.timestamps
    end
    add_index :api_keys, :key, unique: true
    add_index :api_keys, :client_name, unique: true, where: "deactived_at IS NULL"
  end
end
