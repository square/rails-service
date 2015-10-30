module Rails
  module Service
    class DependencyGraph
      class CycleDependencyFoundError < StandardError; end

      def initialize
        @edges = Hash.new { |h, k| h[k] = [] }
        @resolved = Set.new
        @unresolved = Set.new
        @order = []
      end

      def add_edge(node, edge)
        @edges[node] << edge
      end

      def resolve
        @order = []
        @edges.each { |node, edges| dfs(node) unless @resolved.include?(node) }
        order
      end

      def order
        @order # reverse post order
      end

      private

      def dfs(node)
        @unresolved.add(node)
        if @edges.has_key?(node)
          @edges.fetch(node).each do |edge|
            unless @resolved.include?(edge)
              raise CycleDependencyFoundError if @unresolved.include?(edge)
              dfs(edge)
            end
          end
        end
        @resolved.add(node)
        @unresolved.delete(node)
        @order.push(node)
      end
    end
  end
end
