ARM_EMPTY = True

class Predicate:

	def _on(self, x, y):
		self.name = 'on'
		self.on_x = x 
		self.on_y = y

		return self

	def _ont(self, x):
		self.name = 'ont'
		self.on_x = x 

		return self

	def _clear(self, x):
		self.name = 'clear'
		self.on_x = x 

		return self

	@staticmethod
	def on(x, y):
		return Predicate()._on(x, y)

	@staticmethod
	def ont(x):
		return Predicate()._ont(x)

	@staticmethod
	def clear(x):
		return Predicate()._clear(x)


	def check(self):
		if self.name == 'on':
			pass 
		if self.name == 'ont':
			pass
		if self.name == 'clear':
			pass

	def __repr__(self):
		return 'ON(' + str(self.on_x) + ',' + str(self.on_y) + ')'


class ConjucatePredicate:

	def __init__(self, predicates):
		self.ons = predicates

	@staticmethod
	def pred(predicates):
		return ConjucatePredicate(predicates)

	def __repr__(self):
		string = ''
		for x, y in self.ons:
			string += 'ON(' + str(x) + ',' + str(y) + ') ^ '

		string += 'END'

		return string

class Action:
	pass

class PickupAction(Action):

	@staticmethod
	def pre_conditions(X):
		conds = []
		conds.append(Predicate.)


class Block:

	def __init__(self, name, above_block, below_block):
		self.name = name 
		self.above_block = above_block
		self.below_block = below_block

	def __repr__(self):
		return self.name 

class BlockWorld:

	def __init__(self, name, config_stacks):
		self.name = name
		self.no_of_stacks = len(config_stacks)
		self.config_stacks = config_stacks

	def solve(self, goal_world):
		solution_goal_stack = []



		solution_goal_stack.append(ConjucatePredicate.pred([('C','A'), ('B','D')]))

		solution_goal_stack.append(Predicate.on('C','A'))
		solution_goal_stack.append(Predicate.on('B','D'))




	def print(self):

		print()
		print(self.name)
		print()

		max_len = len(self.config_stacks[0])
		for stack in self.config_stacks:
			if len(stack) > max_len:
				max_len = len(stack)

		for l in range(max_len - 1 ,-1,-1):
			for stack in self.config_stacks:
				if l < len(stack):
					print(stack[l], end='')
				print('\t', end='')
			print()

	def __eq__(self, other):
		for self_stack, goal_stack in zip(self.config_stacks, other.config_stacks):
			if self_stack != goal_stack:
				return False 
		return True



def main():
	init_world = BlockWorld('Initial Block World', [['A','B'], ['C'], ['D'] ])
	goal_world = BlockWorld('Goal Block World',    [['A','C'] ,['D','B']])
	init_world.print()
	goal_world.print()

	init_world.solve(goal_world)

	p = Predicate.on('A','B')
	print(p)

	p = ConjucatePredicate.pred([('A','B'), ('B','C')])
	print(p)
	print(init_world == goal_world)


if __name__ == '__main__':
	main()