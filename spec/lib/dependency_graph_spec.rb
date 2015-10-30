require 'spec_helper'

RSpec.describe Rails::Service::DependencyGraph do
  let(:graph) { described_class.new }

  describe 'resolve tree' do
    before do
      graph.add_edge(1, 2)
      graph.add_edge(1, 3)
      graph.add_edge(1, 4)
      graph.add_edge(3, 6)
      graph.add_edge(4, 6)
      graph.add_edge(5, 3)
      graph.add_edge(5, 4)
      graph.add_edge(7, 5)
      graph.add_edge(7, 8)
    end

    it 'should resolve' do
      order = [2, 6, 3, 4, 1, 5, 8, 7]
      expect(graph.resolve).to eq order
      expect(graph.order).to eq order
    end

    it 'shoudl raise cycle error' do
      graph.add_edge(8, 9)
      graph.add_edge(9, 7)
      expect { graph.resolve }.to raise_error Rails::Service::DependencyGraph::CycleDependencyFoundError
    end
  end
end
