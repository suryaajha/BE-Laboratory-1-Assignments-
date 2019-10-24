from queue import PriorityQueue

class PuzzleState:

	def __init__(self, current_config, g, puzzle):
		self.current_config = current_config
		self.puzzle = puzzle
		self.g = g
		self.h = self.calculate_h(self.current_config, puzzle)
		self.f = self.h

	def calculate_h(self, config, puzzle):
		h_score = 0
		for g_tile, c_tile in zip(puzzle.goal_config, config):
			if g_tile != c_tile and g_tile != ' ':
				h_score += 1

		return h_score

	@staticmethod
	def print_puzzle(config):
		k = 0 
		for _ in range(3):
			for _ in range(3):
				print(config[k], end=' ')
				k += 1
			print()

	def print(self):
		print('F-score :', self.f, ', H-score :', self.h, ', G-Score :', self.g)
		k = 0 
		for _ in range(3):
			for _ in range(3):
				print(self.current_config[k], end=' ')
				k += 1
			print()


	@staticmethod
	def swap(string, m, n):
		s = list(string)
		s[m], s[n] = s[n], s[m]

		return ''.join(s)

	def next_move_states(self):
		# 12345678_

		moves = []
		idx_of_blank = self.current_config.index(' ')
		# if up is valid
		if idx_of_blank - 3 >= 0:
			nxt_config = PuzzleState.swap(self.current_config, idx_of_blank, idx_of_blank - 3)
			moves.append(PuzzleState(nxt_config, self.g + 1, self.puzzle))
		# if down is valid
		if idx_of_blank + 3 < 9:
			nxt_config = PuzzleState.swap(self.current_config, idx_of_blank, idx_of_blank + 3)
			moves.append(PuzzleState(nxt_config, self.g + 1, self.puzzle))
		# if left is valid
		# if not (idx_of_blank - 1 == -1 or idx_of_blank - 1 == 2 or idx_of_blank - 1 == 5):
		if (idx_of_blank - 1) % 3 != 2:
			nxt_config = PuzzleState.swap(self.current_config, idx_of_blank, idx_of_blank - 1)
			moves.append(PuzzleState(nxt_config, self.g + 1, self.puzzle))
		# if right is valid
		if (idx_of_blank + 1) % 3 != 0:
			nxt_config = PuzzleState.swap(self.current_config, idx_of_blank, idx_of_blank + 1)
			moves.append(PuzzleState(nxt_config, self.g + 1, self.puzzle))

		return moves

	def __eq__(self, other_state):
		return self.current_config == other_state.current_config

	def __lt__(self, other_state):
		return self.f <= other_state.f

	def __repr__(self):
		return self.current_config


class Puzzle:

	def __init__(self, initial_config, goal_config):
		self.initial_config = initial_config
		self.goal_config = goal_config

		print('Initial State')
		PuzzleState.print_puzzle(self.initial_config)

		print()
		print()
		print('Goal State')
		PuzzleState.print_puzzle(self.goal_config)


	def show_output(self, parent):
		state = self.goal_config
		move_seq = []
		while parent[state] is not None:
			move_seq.append(parent[state])
			state = parent[state].current_config

		levels = 0 
		for move in move_seq[::-1]:
			move.print()
			levels += 1

		PuzzleState(self.goal_config, levels, self).print()

	def solve(self):
		parent = {}
		search_lst_pq = PriorityQueue();
		init_puzzle_state = PuzzleState(self.initial_config, 0, self)
		search_lst_pq.put(init_puzzle_state)
		parent[init_puzzle_state.current_config] = None 

		while not search_lst_pq.empty():
			puzzle_state = search_lst_pq.get()

			if puzzle_state.h == 0:
				break

			for move in puzzle_state.next_move_states():
				if str(move) not in parent:
					search_lst_pq.put(move)
					parent[str(move)] = puzzle_state

		self.show_output(parent)


def main():
	puzzle = Puzzle(' 12345678', '8126453 7')

	print()
	print()
	puzzle.solve()


if __name__ == '__main__':
	main()


