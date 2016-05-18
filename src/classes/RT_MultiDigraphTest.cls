@isTest class RT_MultiDigraphTest {

	@isTest static void testMultiDigraph() {
		RT_MultiDigraph graph = new RT_MultiDigraph();
		
		graph.addNode(1);
		graph.addNode(2);
		graph.addNode(3);
		graph.addNode(4);
		graph.addNode(5);
		
		System.assertEquals(5, graph.size());
		
		System.assertEquals(true, graph.nodeExists(1));
		System.assertEquals(true, graph.nodeExists(2));
		System.assertEquals(true, graph.nodeExists(3));
		System.assertEquals(true, graph.nodeExists(4));
		System.assertEquals(true, graph.nodeExists(5));
		
		graph.addEdge(2, 3, '1');
		graph.addEdge(3, 4, '2');
		graph.addEdge(3, 4, '2b');
		graph.addEdge(1, 4, '3');
		graph.addEdge(1, 3, '4a');
		graph.addEdge(1, 3, '4b');
		graph.addEdge(5, 1, '5a');
		graph.addEdge(5, 1, '6b');
		
		System.assertEquals(8, graph.getEdges().size());
		System.assertEquals(5, graph.getNodes().size());
		System.assertEquals(5, graph.incomingEdges.size());
		System.assertEquals(5, graph.outgoingEdges.size());
		System.assertEquals(8, graph.edgeSources.size());
		System.assertEquals(8, graph.edgeTargets.size());
		
		graph.removeNode(5);
		graph.removeEdge('2b');
		
		System.assertEquals(5, graph.getEdges().size());
		System.assertEquals(4, graph.getNodes().size());
		System.assertEquals(4, graph.incomingEdges.size());
		System.assertEquals(4, graph.outgoingEdges.size());
		System.assertEquals(5, graph.edgeSources.size());
		System.assertEquals(5, graph.edgeTargets.size());

		System.assertEquals(4, graph.size());
		System.assertEquals(false, graph.nodeExists(5));
		System.assertEquals(false, graph.edgeExists(5, 1));
		
		RT_MultiDigraph reversed = graph.copy().reverse();
		System.assertEquals(4, reversed.size());
		System.assertEquals(true, reversed.edgeExists(3, 2));
		System.assertEquals(true, reversed.edgeExists(4, 3));
		System.assertEquals(true, reversed.edgeExists(4, 1));
		System.assertEquals(true, reversed.edgeExists(3, 1));
		
		System.assertEquals(true, graph.edgeExists(2, 3));
		System.assertEquals(false, graph.edgeExists(1, 2));
		
		System.assertEquals(5, graph.getEdges().size());
		System.assertEquals(4, graph.getNodes().size());
		System.assertEquals(4, graph.incomingEdges.size());
		System.assertEquals(4, graph.outgoingEdges.size());
		System.assertEquals(5, graph.edgeSources.size());
		System.assertEquals(5, graph.edgeTargets.size());
		
		System.assertEquals(2, graph.targetNodes(1).size());
		System.assertEquals(1, graph.targetNodes(2).size());
		System.assertEquals(1, graph.targetNodes(3).size());
		System.assertEquals(0, graph.targetNodes(4).size());
		
		System.assertEquals(true, graph.nodeExists(1));
		System.assertEquals(0, graph.incomingEdges.get(1).size());

		System.assertEquals(0, graph.sourceNodes(1).size());
		System.assertEquals(0, graph.sourceNodes(2).size());
		System.assertEquals(2, graph.sourceNodes(3).size());
		System.assertEquals(2, graph.sourceNodes(4).size());
		
		graph.addNode(5);
		System.assertEquals(true, graph.sourceNodes(6).isEmpty());
		
		graph.removeEdge(1, 6);
		
		graph.addEdge(4, 2, '7');
		try {
			graph.toposort();
			System.assert(false);
		}
		catch (RT_MultiDigraph.IllegalArgumentException e) {}
		
		graph.removeEdge(4, 2);
		
		System.assertEquals(5, graph.toposort().size());
		
		graph.clear();
		System.assertEquals(true, graph.isEmpty());
	}
}