@isTest class RT_MultiDigraphTest {

	@isTest static void testMultiDigraph() {
		RT_MultiDigraph graph = new RT_MultiDigraph();
		
		RT_MultiDigraph.Node n1 = new RT_MultiDigraph.ValueNode(1);
		RT_MultiDigraph.Node n2 = new RT_MultiDigraph.ValueNode(2);
		RT_MultiDigraph.Node n3 = new RT_MultiDigraph.ValueNode(3);
		RT_MultiDigraph.Node n4 = new RT_MultiDigraph.ValueNode(4);
		RT_MultiDigraph.Node n5 = new RT_MultiDigraph.ValueNode(5);
		RT_MultiDigraph.Node n6 = new RT_MultiDigraph.ValueNode(6);
		RT_MultiDigraph.Edge e1 = new RT_MultiDigraph.ValueEdge(1);
		RT_MultiDigraph.Edge e2 = new RT_MultiDigraph.ValueEdge(2);
		RT_MultiDigraph.Edge e3 = new RT_MultiDigraph.ValueEdge(3);
		RT_MultiDigraph.Edge e4 = new RT_MultiDigraph.ValueEdge(4);
		RT_MultiDigraph.Edge e5 = new RT_MultiDigraph.ValueEdge(5);
		RT_MultiDigraph.Edge e6 = new RT_MultiDigraph.ValueEdge(6);
		RT_MultiDigraph.Edge e7 = new RT_MultiDigraph.ValueEdge(7);
		RT_MultiDigraph.Edge e8 = new RT_MultiDigraph.ValueEdge(8);
		RT_MultiDigraph.Edge e9 = new RT_MultiDigraph.ValueEdge(9);

		graph.addNode(n1);
		graph.addNode(n2);
		graph.addNode(n3);
		graph.addNode(n4);
		graph.addNode(n5);
		
		System.assertEquals(5, graph.size());
		
		System.assertEquals(true, graph.nodeExists(n1));
		System.assertEquals(true, graph.nodeExists(n2));
		System.assertEquals(true, graph.nodeExists(n3));
		System.assertEquals(true, graph.nodeExists(n4));
		System.assertEquals(true, graph.nodeExists(n5));
		
		graph.addEdge(n2, n3, e1);
		graph.addEdge(n3, n4, e2);
		graph.addEdge(n3, n4, e3);
		graph.addEdge(n1, n4, e4);
		graph.addEdge(n1, n3, e5);
		graph.addEdge(n1, n3, e6);
		graph.addEdge(n5, n1, e7);
		graph.addEdge(n5, n1, e8);
		
		System.assertEquals(8, graph.getEdges().size());
		System.assertEquals(5, graph.getNodes().size());
		System.assertEquals(5, graph.incomingEdges.size());
		System.assertEquals(5, graph.outgoingEdges.size());
		System.assertEquals(8, graph.edgeSources.size());
		System.assertEquals(8, graph.edgeTargets.size());
		
		graph.removeNode(n5);
		graph.removeEdge(e3);
		
		System.assertEquals(5, graph.getEdges().size());
		System.assertEquals(4, graph.getNodes().size());
		System.assertEquals(4, graph.incomingEdges.size());
		System.assertEquals(4, graph.outgoingEdges.size());
		System.assertEquals(5, graph.edgeSources.size());
		System.assertEquals(5, graph.edgeTargets.size());

		System.assertEquals(4, graph.size());
		System.assertEquals(false, graph.nodeExists(n5));
		System.assertEquals(false, graph.edgeExists(n5, n1));
		
		RT_MultiDigraph reversed = graph.copy().reverse();
		System.assertEquals(4, reversed.size());
		System.assertEquals(true, reversed.edgeExists(n3, n2));
		System.assertEquals(true, reversed.edgeExists(n4, n3));
		System.assertEquals(true, reversed.edgeExists(n4, n1));
		System.assertEquals(true, reversed.edgeExists(n3, n1));
		
		System.assertEquals(true, graph.edgeExists(n2, n3));
		System.assertEquals(false, graph.edgeExists(n1, n2));
		
		System.assertEquals(5, graph.getEdges().size());
		System.assertEquals(4, graph.getNodes().size());
		System.assertEquals(4, graph.incomingEdges.size());
		System.assertEquals(4, graph.outgoingEdges.size());
		System.assertEquals(5, graph.edgeSources.size());
		System.assertEquals(5, graph.edgeTargets.size());
		
		System.assertEquals(2, graph.targetNodes(n1).size());
		System.assertEquals(1, graph.targetNodes(n2).size());
		System.assertEquals(1, graph.targetNodes(n3).size());
		System.assertEquals(0, graph.targetNodes(n4).size());
		
		System.assertEquals(true, graph.nodeExists(n1));
		System.assertEquals(0, graph.incomingEdges.get(n1).size());

		System.assertEquals(0, graph.sourceNodes(n1).size());
		System.assertEquals(0, graph.sourceNodes(n2).size());
		System.assertEquals(2, graph.sourceNodes(n3).size());
		System.assertEquals(2, graph.sourceNodes(n4).size());
		
		graph.addNode(n5);
		System.assertEquals(true, graph.sourceNodes(n6).isEmpty());
		
		graph.removeEdge(n1, n6);
		
		graph.addEdge(n4, n2, e9);
		try {
			graph.toposort();
			System.assert(false);
		}
		catch (RT_MultiDigraph.IllegalArgumentException e) {}
		
		graph.removeEdge(n4, n2);
		
		System.assertEquals(5, graph.toposort().size());
		
		graph.clear();
		System.assertEquals(true, graph.isEmpty());
	}
}