public class RT_MultiDigraph {

	/**
	 * Toposort sorting strategy singleton
	 */
	private static final SortingStrategy TOPOSORT = new TopoSort();
	
	public final Map<Object, Set<Object>> outgoingEdges;
	public final Map<Object, Set<Object>> incomingEdges;
	
	public final Map<Object, Object> edgeSources;
	public final Map<Object, Object> edgeTargets;
	
	/**
	 * Construct an empty graph
	 */
	public RT_MultiDigraph() {
		this(
		    new Map<Object, Set<Object>>(),
		    new Map<Object, Set<Object>>(),
		    new Map<Object, Object>(),
		    new Map<Object, Object>()
		);
	}
	
	/**
	 * Construct a predefined graph
	 */
	public RT_MultiDigraph(
	    Map<Object, Set<Object>> outgoingEdges,
	    Map<Object, Set<Object>> incomingEdges,
	    Map<Object, Object> edgeSources,
	    Map<Object, Object> edgeTargets
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
	public void addNode(Object node) {
		if (!nodeExists(node)) {
			outgoingEdges.put(node, new Set<Object>());
			incomingEdges.put(node, new Set<Object>());
		}
	}
	
	/**
	 * Remove a node from the graph
	 */
	public void removeNode(Object node) {
		if (nodeExists(node)) {
			Set<Object> edges = outgoingEdges.get(node).clone();
			edges.addAll(incomingEdges.get(node));
			for (Object edge : edges) {
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
	public void addEdge(Object source, Object target, Object edge) {
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
	public void removeEdge(Object edge) {
		if (edgeExists(edge)) {
			Object sourceNode = edgeSources.get(edge);
			Object targetNode = edgeTargets.get(edge);
			outgoingEdges.get(sourceNode).remove(edge);
			incomingEdges.get(targetNode).remove(edge);
			edgeSources.remove(edge);
			edgeTargets.remove(edge);
		}
	}
	
	/**
	 * Remove edge from source (the dependency) to target from the graph
	 */
	public void removeEdge(Object source, Object target) {
		if (nodeExists(source) && nodeExists(target)) {
			Set<Object> edges = outgoingEdges.get(source).clone();
			edges.retainAll(incomingEdges.get(target));
			System.debug(edges);
			for (Object edge : edges) {
				removeEdge(edge);
			}
		}
	}
	
	/**
	 * @return all nodes in the graph
	 */
	public Set<Object> getNodes() {
		// incoming and outgoing will always have the same keys
		return outgoingEdges.keySet().clone();
	}
	
	/**
	 * @return all edges in the graph
	 */
	public Set<Object> getEdges() {
		Set<Object> edges = edgeSources.keySet().clone();
		edges.addAll(edgeTargets.keySet());
		return edges;
	}
	
	/**
	 * @param node
	 * @return whether the node exists in the graph
	 */
	public Boolean nodeExists(Object node) {
		return getNodes().contains(node);
	}
	
	/**
	 * @param edge
	 * @return whether an edge exists
	 */
	public Boolean edgeExists(Object edge) {
		return getEdges().contains(edge);
	}
	
	/**
	 * @param source
	 * @param target
	 * @return whether an edge exists from source to target
	 */
	public Boolean edgeExists(Object source, Object target) {
		return targetNodes(source).contains(target);
	}
	
	/**
	 * Get the nodes of edges pointing away from a node
	 * @param source
	 * @return nodes pointing from the source node
	 */
	public Set<Object> targetNodes(Object source) {
		if (nodeExists(source)) {
			Set<Object> edges = outgoingEdges.get(source);
			Set<Object> targetNodes = new Set<Object>();
			for (Object edge : edges) {
				targetNodes.add(edgeTargets.get(edge));
			}
			return targetNodes;
		}
		return new Set<Object>();
	}
	
	/**
	 * Get the nodes of edges pointing to a node
	 *
	 * @param node
	 * @return nodes of edges to target node
	 */
	public Set<Object> sourceNodes(Object target) {
		if (nodeExists(target)) {
			Set<Object> edges = incomingEdges.get(target);
			Set<Object> sourceNodes = new Set<Object>();
			for (Object edge : edges) {
				sourceNodes.add(edgeSources.get(edge));
			}
			return sourceNodes;
		}
		return new Set<Object>();
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
	public List<Object> toposort() {
		return TOPOSORT.sort(this);
	}
	
	public interface SortingStrategy {
		List<Object> sort(RT_MultiDigraph g);
	}
	
	private class TopoSort implements SortingStrategy {
		/**
		 * Given a directed acyclic graph, returns a topological sorting of the nodes
		 * in the graph. If the input graph is not a DAG, throws an IllegalArgumentException.
		 */
		public List<Object> sort(RT_MultiDigraph g) {
			// Reverse graph from the input graph.
			RT_MultiDigraph reversed = g.reverse();
			
			// Topologically sorted result
			List<Object> result = new List<Object>();
			
			// Set of visited nodes
			Set<Object> visited = new Set<Object>();
			
			/* Set of fully expanded nodes. if the graph contains a cycle, then we can
			 * detect this by noting that a node has been explored but not fully expanded.
			 */
			Set<Object> expanded = new Set<Object>();
			
			// Fire off a DFS from each node in the graph.
			for (Object node : reversed.getNodes()) {
				explore(node, reversed, result, visited, expanded);
			}
			// Hand back the resulting ordering.
			return result;
		}
		
		
		/**
		 * Recursively perform a DFS from the specified node, marking all nodes
		 * encountered by the search.
		 */
		private void explore(Object node, RT_MultiDigraph g, List<Object> ordering,
		                     Set<Object> visited, Set<Object> expanded) {
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
			for (Object predecessor : g.targetNodes(node)) {
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