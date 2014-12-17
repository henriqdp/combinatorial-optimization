class Knapsack
	def initialize size, profits, weights, capacity
		@size = size
		@profits = profits
		@weights = weights
		@capacity = capacity
	end

	def optimal_heuristic
	end

	def sahni_heuristic
	end
end

problems = Array.new
entries =  Dir.glob('*.txt')
entries.each do |filename|
	File.open(filename, 'r+') do |file|
		plaintext = file.read
		plaintext = plaintext.split("\r\n")
		#puts plaintext.inspect
		problems << Knapsack.new(plaintext[0].to_i, 
								 plaintext[1].split(" ").collect{|x| x = x.to_i}, 
							     plaintext[2].split(" ").collect{|x| x = x.to_i},
							     plaintext[3].to_i)

	end
end

puts problems.inspect