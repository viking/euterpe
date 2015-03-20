require 'euterpe/repositories/song_repository'

RSpec.describe Euterpe::SongRepository do
  let(:adapter) { double('adapter') }
  let(:song_class) { double('song class') }
  subject(:repo) { Euterpe::SongRepository.new(adapter) }

  before(:example) do
    stub_const("Euterpe::Song", song_class)
  end

  describe "#setup" do
    it "should use adapter to create collection" do
      expect(adapter).to receive(:create_collection).with('songs', [
        { 'name' => 'title', 'type' => 'string' },
        { 'name' => 'artist', 'type' => 'string' },
        { 'name' => 'album', 'type' => 'string' },
        { 'name' => 'track', 'type' => 'integer' },
        { 'name' => 'filename', 'type' => 'string' }
      ])
      repo.setup
    end
  end

  describe "#find" do
    it "should use adapter to find records without criteria" do
      song = double('song')
      expect(adapter).to receive(:find).with('songs') { [{'id' => 1, 'title' => 'Foo'}] }
      expect(song_class).to receive(:new).with({'id' => 1, 'title' => 'Foo'}) { song }
      result = repo.find
      expect(result).to eq([song])
    end

    it "should use adapter to find records with criteria" do
      song = double('song')
      expect(adapter).to receive(:find).with('songs', 'id' => 1) { [{'id' => 1, 'title' => 'Foo'}] }
      expect(song_class).to receive(:new).with({'id' => 1, 'title' => 'Foo'}) { song }
      result = repo.find('id' => 1)
      expect(result).to eq([song])
    end
  end

  describe "#create" do
    it "should use adapter to insert record" do
      song = double('song', {
        'title' => 'foo',
        'artist' => 'bar',
        'album' => 'baz',
        'track' => 1,
        'filename' => 'derp.mp3'
      })
      expect(adapter).to receive(:insert).with('songs', {
        'title' => 'foo',
        'artist' => 'bar',
        'album' => 'baz',
        'track' => 1,
        'filename' => 'derp.mp3'
      }) { 1 }
      result = repo.create(song)
      expect(result).to eq(1)
    end
  end
end
