public class RT_MultiDigraph {

	/**
	 * Toposort sorting strategy singleton
	 */
	private static final SortingStrategy TOPOSORT = new TopoSort();
	
	public final Map<Node, Set<Edge>> outgoingEdges;
	public final Map<Node, Set<Edge>> incomingEdges;
	
	public final Map<Edge, Node> edgeSources;
	public final Map<Edge, Node> edgeTargets;
	
	
	/**
	 * Construct an empty graph
	 */
	public RT_MultiDigraph() {
		this(
		    new Map<Node, Set<Edge>>(),
		    new Map<Node, Set<Edge>>(),
		    new Map<Edge, Node>(),
		    new Map<Edge, Node>()
		);
	}
	
	/**
	 * Construct a predefined graph
	 */
	public RT_MultiDigraph(
	    Map<Node, Set<Edge>> outgoingEdges,
	    Map<Node, Set<Edge>> incomingEdges,
	    Map<Edge, Node> edgeSources,
	    Map<Edge, Node> edgeTargets
	) {
		this.outgoingEdges = outgoingEdges.clone();
		this.incomingEdges = incomingEdges.clone();
		this.edgeSources = edgeSources.clone();
		this.edgeTargets = edgeTargets.clone();
	}
	
	/**
	 * Clear the graph
	 */
	public void clear() {
		outgoingEdges.clear();
		incomingEdges.clear();
		edgeSources.clear();
		edgeTargets.clear();
	}
	
	public RT_MultiDigraph copy() {
		return new RT_MultiDigraph(outgoingEdges, incomingEdges, edgeSources, edgeTargets);
	}
	
	/**
	 * @param node node to add to the graph
	 */
	public void addNode(Node node) {
		if (!nodeExists(node)) {
			outgoingEdges.put(node, new Set<Edge>());
			incomingEdges.put(node, new Set<Edge>());
		}
	}
	
	/**
	 * Remove a node from the graph
	 */
	public void removeNode(Node node) {
		if (nodeExists(node)) {
			Set<Edge> edges = outgoingEdges.get(node).clone();
			edges.addAll(incomingEdges.get(node));
			for (Edge edge : edges) {
				removeEdge(edge);
			}
			incomingEdges.remove(node);
			outgoingEdges.remove(node);
		}
	}
	
	/**
	 * Given a source node, and a destination, adds an arc from the
	 * source node to the destination
	 */
	public void addEdge(Node source, Node target, Edge edge) {
		if (!nodeExists(source) || !nodeExists(target)) {
			throw new IllegalArgumentException('source and/or target nodes do not exist');
		}
		if (!edgeExists(edge)) {
			outgoingEdges.get(source).add(edge);
			incomingEdges.get(target).add(edge);
			edgeSources.put(edge, source);
			edgeTargets.put(edge, target);
		}
	}
	
	/**
	 * Remove edge from the graph
	 */
	public void removeEdge(Edge edge) {
		if (edgeExists(edge)) {
			Node sourceNode = edgeSources.get(edge);
			Node targetNode = edgeTargets.get(edge);
			outgoingEdges.get(sourceNode).remove(edge);
			incomingEdges.get(targetNode).remove(edge);
			edgeSources.remove(edge);
			edgeTargets.remove(edge);
		}
	}
	
	/**
	 * Remove edge from source (the dependency) to target from the graph
	 */
	public void removeEdge(Node source, Node target) {
		if (nodeExists(source) && nodeExists(target)) {
			Set<Edge> edges = outgoingEdges.get(source).clone();
			edges.retainAll(incomingEdges.get(target));
			for (Edge edge : edges) {
				removeEdge(edge);
			}
		}
	}
	
	/**
	 * @return all nodes in the graph
	 */
	public Set<Node> getNodes() {
		// incoming and outgoing will always have the same keys
		return outgoingEdges.keySet().clone();
	}
	
	/**
	 * @return all edges in the graph
	 */
	public Set<Edge> getEdges() {
		Set<Edge> edges = edgeSources.keySet().clone();
		edges.addAll(edgeTargets.keySet());
		return edges;
	}
	
	/**
	 * @param node
	 * @return whether the node exists in the graph
	 */
	public Boolean nodeExists(Node node) {
		return getNodes().contains(node);
	}
	
	/**
	 * @param edge
	 * @return whether an edge exists
	 */
	public Boolean edgeExists(Edge edge) {
		return getEdges().contains(edge);
	}
	
	/**
	 * @param source
	 * @param target
	 * @return whether an edge exists from source to target
	 */
	public Boolean edgeExists(Node source, Node target) {
		return targetNodes(source).contains(target);
	}
	
	/**
	 * Get the nodes of edges pointing away from a node
	 * @param source
	 * @return nodes pointing from the source node
	 */
	public Set<Node> targetNodes(Node source) {
		if (nodeExists(source)) {
			Set<Edge> edges = outgoingEdges.get(source);
			Set<Node> targetNodes = new Set<Node>();
			for (Edge edge : edges) {
				targetNodes.add(edgeTargets.get(edge));
			}
			return targetNodes;
		}
		return new Set<Node>();
	}
	
	/**
	 * Get the nodes of edges pointing to a node
	 *
	 * @param node
	 * @return nodes of edges to target node
	 */
	public Set<Node> sourceNodes(Node target) {
		if (nodeExists(target)) {
			Set<Edge> edges = incomingEdges.get(target);
			Set<Node> sourceNodes = new Set<Node>();
			for (Edge edge : edges) {
				sourceNodes.add(edgeSources.get(edge));
			}
			return sourceNodes;
		}
		return new Set<Node>();
	}
	
	/**
	 * @return number of nodes in the graph
	 */
	public Integer size() {
		return outgoingEdges.size();
	}
	
	/**
	 * @return whether the graph is empty
	 */
	public Boolean isEmpty() {
		return outgoingEdges.isEmpty();
	}
	
	/**
	 * @return the reverse of the input graph
	 */
	public RT_MultiDigraph reverse() {
		return new RT_MultiDigraph(incomingEdges, outgoingEdges, edgeTargets, edgeSources);
	}
	
	/**
	 * @return topologically sorted list of the nodes in the graph.
	 */
	public List<Node> toposort() {
		return TOPOSORT.sort(this);
	}
	
	public interface SortingStrategy {
		List<Node> sort(RT_MultiDigraph g);
	}
	
	private interface BaseElement {
		Boolean equals(Object o);
		Integer hashCode();
	}
	
	public interface Node extends BaseElement {}
	
	public interface Edge extends BaseElement {}
	
	public class ValueNode implements Node {

		public final Object value;
		private final Integer hashCode;

		public ValueNode(Object value) {
			this.value = value;
			this.hashCode = hash(value);
		}

		private Integer hash(Object value) {
			Integer res = 17;
			res = 31 * res + System.hashCode(ValueNode.class);
			res = 31 * res + (value == null ? 0 : System.hashCode(value));
			return res;
		}

		public Boolean equals(Object o) {
			if (o == null) { return false; }
			if (o === this) { return true; } // *NOPAD*
			if (!(o instanceof ValueNode)) { return false; }
			ValueNode n = (ValueNode) o;
			return value == n.value;
		}

		public Integer hashCode() {
			return hashCode;
		}
	}
	
	public class ValueEdge implements Edge {

		public final Object value;
		private final Integer hashCode;

		public ValueEdge(Object value) {
			this.value = value;
			this.hashCode = hash(value);
		}

		private Integer hash(Object value) {
			Integer res = 17;
			res = 31 * res + System.hashCode(ValueEdge.class);
			res = 31 * res + (value == null ? 0 : System.hashCode(value));
			return res;
		}

		public Boolean equals(Object o) {
			if (o == null) { return false; }
			if (o === this) { return true; } // *NOPAD*
			if (!(o instanceof ValueEdge)) { return false; }
			ValueEdge e = (ValueEdge) o;
			return value == e.value;
		}

		public Integer hashCode() {
			return hashCode;
		}
	}
	
	private class TopoSort implements SortingStrategy {
		/**
		 * Given a directed acyclic graph, returns a topological sorting of the nodes
		 * in the graph. If the input graph is not a DAG, throws an IllegalArgumentException.
		 */
		public List<Node> sort(RT_MultiDigraph g) {
			// Reverse graph from the input graph.
			RT_MultiDigraph reversed = g.reverse();
			
			// Topologically sorted result
			List<Node> result = new List<Node>();
			
			// Set of visited nodes
			Set<Node> visited = new Set<Node>();
			
			/* Set of fully expanded nodes. if the graph contains a cycle, then we can
			 * detect this by noting that a node has been explored but not fully expanded.
			 */
			Set<Node> expanded = new Set<Node>();
			
			// Fire off a DFS from each node in the graph.
			for (Node node : reversed.getNodes()) {
				explore(node, reversed, result, visited, expanded);
			}
			// Hand back the resulting ordering.
			return result;
		}
		
		
		/**
		 * Recursively perform a DFS from the specified node, marking all nodes
		 * encountered by the search.
		 */
		private void explore(Node node, RT_MultiDigraph g, List<Node> ordering,
		                     Set<Node> visited, Set<Node> expanded) {
			// Check whether we've been here before. If so, we should stop the search
			if (visited.contains(node)) {
				/* There are two cases to consider. First, if this node has
				 * already been expanded, then it's already been assigned a
				 * position in the final topological sort and we don't need to
				 * explore it again. However, if it hasn't been expanded, it means
				 * that we've just found a node that is currently being explored,
				 * and therefore is part of a cycle. In that case, we should
				 * report an error.
				 */
				if (expanded.contains(node)) {
					return;
				}
				throw new IllegalArgumentException('Graph contains a cycle.');
			}
			
			// Mark that we've been here
			visited.add(node);
			
			// Recursively explore all of the node's predecessors
			for (Node predecessor : g.targetNodes(node)) {
				explore(predecessor, g, ordering, visited, expanded);
			}
			
			/* Having explored all of the node's predecessors, we
			 * can now add this node to the sorted ordering
			 */
			ordering.add(node);
			
			// Similarly, mark that this node is done being expanded
			expanded.add(node);
		}
	}
	
	public class IllegalArgumentException extends Exception {}
}