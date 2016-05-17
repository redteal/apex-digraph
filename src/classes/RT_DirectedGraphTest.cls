@isTest class RT_DirectedGraphTest {
    
    @isTest static void testDigraph() {
        RT_DirectedGraph graph = new RT_DirectedGraph();
        
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
        
        graph.addEdge(2, 3);
        graph.addEdge(3, 4);
        graph.addEdge(1, 4);
        graph.addEdge(1, 3);
        graph.addEdge(5, 1);

        graph.removeNode(5);
        System.assertEquals(4, graph.size());
        System.assertEquals(false, graph.nodeExists(5));
        System.assertEquals(false, graph.edgeExists(5, 1));
        
        RT_DirectedGraph reversed = graph.copy().reverse();
        System.assertEquals(4, reversed.size());
        System.assertEquals(true, reversed.edgeExists(3, 2));
        System.assertEquals(true, reversed.edgeExists(4, 3));
        System.assertEquals(true, reversed.edgeExists(4, 1));
        System.assertEquals(true, reversed.edgeExists(3, 1));
        
        System.assertEquals(true, graph.edgeExists(2, 3));
        System.assertEquals(false, graph.edgeExists(1, 2));
        
        System.assertEquals(2, graph.edgesFrom(1).size());
        System.assertEquals(1, graph.edgesFrom(2).size());
        System.assertEquals(1, graph.edgesFrom(3).size());
        System.assertEquals(0, graph.edgesFrom(4).size());

        System.assertEquals(0, graph.edgesTo(1).size());
        System.assertEquals(0, graph.edgesTo(2).size());
        System.assertEquals(2, graph.edgesTo(3).size());
        System.assertEquals(2, graph.edgesTo(4).size());
        
        graph.addNode(5);
        System.assertEquals(true, graph.edgesFrom(6).isEmpty());
        
        graph.removeEdge(1, 6);
        
        graph.addEdge(4, 2);
        try {
            graph.toposort();
            System.assert(false);
        }
        catch (RT_DirectedGraph.IllegalArgumentException e) {}
        
        graph.removeEdge(4, 2);
        
        System.assertEquals(5, graph.toposort().size());
        
        graph.clear();
        System.assertEquals(true, graph.isEmpty());
    }
}