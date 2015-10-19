json.array!(@notes) do |note|
  json.extract! note, :id, :title, :tags, :body
  json.url note_url(note, format: :json)
end
