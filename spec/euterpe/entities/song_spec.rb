require 'euterpe/entities/song'

RSpec.describe Euterpe::Song do
  describe "#initialize" do
    it "should set attributes" do
      song = Euterpe::Song.new({
        'id' => 1,
        'title' => 'foo',
        'artist' => 'bar',
        'album' => 'baz',
        'track' => 1,
        'filename' => 'foo.mp3'
      })
      expect(song.id).to eq(1)
      expect(song.title).to eq('foo')
      expect(song.artist).to eq('bar')
      expect(song.album).to eq('baz')
      expect(song.track).to eq(1)
      expect(song.filename).to eq('foo.mp3')
    end
  end
end
