require 'euterpe/mapping'

RSpec.describe Euterpe::Mapping do
  subject(:mapping) do
    Euterpe::Mapping.new(config)
  end

  context "with a one-field map" do
    let(:config) do
      {
        'Foo' => [
          { 'from' => 'foo', 'to' => 'bar', 'type' => 'string' }
        ]
      }
    end

    describe "#map" do
      it "should rename field name" do
        expect(mapping.map('Foo', { 'foo' => 'test' })).to eq({ 'bar' => 'test' })
      end
    end

    describe "#unmap" do
      it "should rename field name" do
        expect(mapping.unmap('Foo', { 'bar' => 'test' })).to eq({ 'foo' => 'test' })
      end
    end
  end
end
