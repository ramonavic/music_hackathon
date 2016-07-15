class CreateArtistPages < ActiveRecord::Migration
  def change
    create_table :artist_pages do |t|
      t.string :artist_name
      t.text :content

      t.timestamps null: false
    end
  end
end
