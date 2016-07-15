class AddUserToArtistPages < ActiveRecord::Migration
  def change
    add_reference :artist_pages, :user, index: true, foreign_key: true
  end
end
