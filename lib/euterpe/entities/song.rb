module Euterpe
  class Song
    attr_accessor :id, :title, :artist, :album, :track, :filename

    def initialize(attributes)
      @id = attributes['id']
      @title = attributes['title']
      @artist = attributes['artist']
      @album = attributes['album']
      @track = attributes['track']
      @filename = attributes['filename']
    end
  end
end
