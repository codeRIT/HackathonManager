json.array! @events do |event|
  json.id           event.id
  json.title        event.title
  json.description  event.description
  json.category     event.category
  json.location     event.location
  json.start        event.start
  json.finish       event.finish
  json.created_at   event.created_at
  json.updated_at   event.updated_at
end
