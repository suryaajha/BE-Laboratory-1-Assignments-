from queue import Queue
import networkx as nx
import matplotlib.pyplot as plt
from queue import PriorityQueue

class Pair:
	def __init__(self, vertex, cost):
		self.vertex = vertex
		self.cost = cost

	def __lt__(self, other):
		return self.cost <= other.cost

class Vertice:
	def __init__(self, name):
		self.name = name 

class Graph:
	def __init__(self, vertices, edges, directed=True):

		self.adjancecy_matrix = {}
		self.directed = directed
		for v in vertices:	
			self.adjancecy_matrix[v] = []
		for source, dest, weight in edges:
			self.adjancecy_matrix[source].append((dest, weight))
			if not directed:
				self.adjancecy_matrix[dest].append((source, weight))

	def print_adjancecy_matrix(self):

		print('Adjacency Matrix of Given Graph')
		print()

		for vertice, edges in self.adjancecy_matrix.items():
			print(vertice, ' -> ', edges)

	def draw(self):
		if self.directed:
			g = nx.DiGraph()
		else:
			g = nx.Graph()

		for vertex in self.adjancecy_matrix.keys():
			g.add_node(vertex)

		for vertex in self.adjancecy_matrix.keys():
			for edge in self.adjancecy_matrix[vertex]:
				g.add_edge(vertex, edge[0], weight=edge[1])

		nx.draw(g, with_labels=True)
		plt.show()

	def give_edge(self, a, b):
		for edge in self.adjancecy_matrix[a]:
			neighbour, weight = edge
			if neighbour == b:
				return (neighbour, weight)

	def show_output(self, parent, target_node):
		cost = 0
		node = target_node
		path = []
		path.append(target_node)
		while parent[node] is not None:
			path.append(parent[node])
			node = parent[node]

		path.reverse()

		for p in path:
			print(p, '--> ', end='')

		print('Found the Path')

		for i in range(len(path) - 1):
			cost += self.give_edge(path[i], path[i+1])[1]

		print('Total Cost using BFS is :', cost)

	def best_first_search(self, init_node, target_node):

		print()
		print('Using Best First Search : Searching',  target_node, 'Starting from :', init_node)
		print()

		parent = {}
		pq = PriorityQueue()
		pq.put(Pair(init_node, 0)) # cost to reach initial node is ZERO
		parent[init_node] = None

		while not pq.empty():
			node_cost_pair = pq.get()
			vertex = node_cost_pair.vertex
			print('Processed Node', vertex)
			if vertex == target_node:
				break 
			for edge in self.adjancecy_matrix[vertex]:
				neighbour, weight = edge
				if neighbour not in parent:
					pq.put(Pair(neighbour, weight))
					parent[neighbour] = vertex

		self.show_output(parent, target_node)

	def a_star_search(self, init_node, target_node):

		print()
		print('Using A* Search  : Searching',  target_node, 'Starting from :', init_node)
		print()

		parent = {}
		pq = PriorityQueue()
		pq.put(Pair(init_node, 0)) # cost to reach initial node is ZERO
		parent[init_node] = None

		while not pq.empty():
			node_cost_pair = pq.get()
			vertex = node_cost_pair.vertex
			print('Processed Node', vertex)
			if vertex == target_node:
				break 
			for edge in self.adjancecy_matrix[vertex]:
				neighbour, weight = edge
				if neighbour not in parent:
					pq.put(Pair(neighbour, weight + node_cost_pair.cost))
					parent[neighbour] = vertex

		self.show_output(parent, target_node)

def main():
	g = Graph(['s','a','b','c','d','e','f','g','h','i','j','k','l','m'], [('s','a',3), ('s','b',6), ('s','c',5), ('a','d',9), ('a','e',8), ('b','f',12), ('b','g',14), ('c','h',7), ('h','i',5), ('h','j',6), ('i','k',1), ('i','l',10), ('i','m',2)])
	
	g.print_adjancecy_matrix()

	g.best_first_search('s','m')

	g.a_star_search('s','m')
	
	# g.draw()

if __name__ == '__main__':
	main()
