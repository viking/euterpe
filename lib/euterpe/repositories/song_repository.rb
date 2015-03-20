module Euterpe
  class SongRepository
    FIELDS = [
      { 'name' => 'title', 'type' => 'string' },
      { 'name' => 'artist', 'type' => 'string' },
      { 'name' => 'album', 'type' => 'string' },
      { 'name' => 'track', 'type' => 'integer' },
      { 'name' => 'filename', 'type' => 'string' }
    ]

    def initialize(adapter)
      @adapter = adapter
    end

    def setup
      @adapter.create_collection('songs', FIELDS)
    end

    def find(criteria = {})
      records =
        if criteria.empty?
          @adapter.find('songs')
        else
          @adapter.find('songs', criteria)
        end

      records.collect do |record|
        Song.new(record)
      end
    end

    def create(song)
      record = {
        'title' => song.title,
        'artist' => song.artist,
        'album' => song.album,
        'track' => song.track,
        'filename' => song.filename
      }
      @adapter.insert('songs', record)
    end
  end
end
