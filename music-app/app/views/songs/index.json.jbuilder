json.array!(@songs) do |song|
  json.extract! song, :id, :title, :text, :artist_id
  json.url song_url(song, format: :json)
end
