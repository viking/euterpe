require 'euterpe/adapters/sqlite_adapter'
require 'tempfile'

RSpec.describe Euterpe::SqliteAdapter do
  let(:database_class) { double("database class") }
  let(:database) { double("database") }

  before(:example) do
    stub_const("SQLite3::Database", database_class)
    allow(database_class).to receive(:new) { database }
  end

  subject(:adapter) do
    Euterpe::SqliteAdapter.new(:path => 'foo.db')
  end

  describe "#initialize" do
    it "should connect to database" do
      expect(database_class).to receive(:new).with('foo.db') { database }
      adapter
    end
  end

  describe "#create_collection" do
    it "should create a database table with a string field" do
      field = { 'name' => 'foo', 'type' => 'string' }
      expect(database).to receive(:execute).with("SELECT name FROM sqlite_master WHERE type = 'table'") { [] }
      expect(database).to receive(:execute).with("CREATE TABLE stuff (id INTEGER PRIMARY KEY, foo TEXT)")
      result = adapter.create_collection('stuff', [field])
      expect(result).to eq(true)
    end

    it "should create a database table with an integer field" do
      field = { 'name' => 'foo', 'type' => 'integer' }
      expect(database).to receive(:execute).with("SELECT name FROM sqlite_master WHERE type = 'table'") { [] }
      expect(database).to receive(:execute).with("CREATE TABLE stuff (id INTEGER PRIMARY KEY, foo INTEGER)")
      result = adapter.create_collection('stuff', [field])
      expect(result).to eq(true)
    end

    it "should not create a database table that already exists" do
      field = { 'name' => 'foo', 'type' => 'string' }
      expect(database).to receive(:execute).with("SELECT name FROM sqlite_master WHERE type = 'table'") { [["stuff"]] }
      expect(database).to_not receive(:execute)
      result = adapter.create_collection('stuff', [field])
      expect(result).to eq(false)
    end
  end

  describe "#insert" do
    it "should insert a record" do
      expect(database).to receive(:execute).with("INSERT INTO stuff (foo, bar) VALUES (?, ?)", ['foo', 'bar'])
      expect(database).to receive(:last_insert_row_id) { 1 }
      result = adapter.insert('stuff', { 'foo' => 'foo', 'bar' => 'bar' })
      expect(result).to eq(1)
    end
  end

  describe "#find" do
    it "should find records with no criteria" do
      expect(database).to receive(:execute).with("PRAGMA table_info(stuff)") { [[0, "id", "INTEGER", 0, nil, 1], [1, "bar", "TEXT", 0, nil, 0]] }
      expect(database).to receive(:execute).with("SELECT id, bar FROM stuff") { [[1, "foo"], [2, "bar"]] }
      result = adapter.find('stuff')
      expect(result).to eq([{'id' => 1, 'bar' => 'foo'}, {'id' => 2, 'bar' => 'bar'}])
    end

    it "should find records with criteria" do
      expect(database).to receive(:execute).with("PRAGMA table_info(stuff)") { [[0, "id", "INTEGER", 0, nil, 1], [1, "bar", "TEXT", 0, nil, 0]] }
      expect(database).to receive(:execute).with("SELECT id, bar FROM stuff WHERE foo = ? AND bar = ?", ["bar", "baz"]) { [[1, "foo"], [2, "bar"]] }
      result = adapter.find('stuff', { 'foo' => 'bar', 'bar' => 'baz' })
      expect(result).to eq([{'id' => 1, 'bar' => 'foo'}, {'id' => 2, 'bar' => 'bar'}])
    end
  end
end
