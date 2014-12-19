$K = 3

class Knapsack
	def initialize size, profits, weights, capacity
		@size = size
		@profits = profits
		@weights = weights
		@capacity = capacity

	end

	def optimal_heuristic
		#initializes the main matrix
		@DP_matrix = Array.new(@size+1)
		.collect{|e| e = Array.new(@capacity+1, -1)}

		#fills the first row with zeros
		@DP_matrix[0].collect!{|e| e = 0}


		#fills the matrix
		for i in 1..@size
			for w in 1..@capacity
				if(w < @weights[i-1])
					@DP_matrix[i][w] = @DP_matrix[i][w-1]
				else
					@DP_matrix[i][w] = [@DP_matrix[i-1][w], @profits[i-1] \
					+ @DP_matrix[i-1][w - @weights[i-1]]].max
				end
			end
		end

		#TODO: backtrack on the matrix to find the items

		puts "Capacity: #{@capacity}"
		puts "Size: #{@size}"

		puts "Total profit: #{@DP_matrix.last.last}"
	end

	def greedy
		_S = Array.new
		_PI = 0
		remaining_capacity = @capacity
		j = 0
		while j < @size && remaining_capacity > 0
			if(@weights[j] <= remaining_capacity)
				_S << j
				_PI += @profits[j]
				remaining_capacity -= @weights[j]
				j += 1
			end
		end

		puts "elements in the sack: #{_S.inspect}"
		puts "total profit: #{_PI}"
	end

	def sahni_heuristic
		#sorts the profits/weights arrays in non-incresing order for ratio profit/weight
		custo_beneficio = Array.new(@size)
		@size.times do |i|
			custo_beneficio[i] = @profits[i].to_f / @weights[i]
		end

		custo_beneficio_sorted = custo_beneficio.sort

		profits_sorted = weights_sorted = Array.new	
		@size.times do |i|
			index = custo_beneficio_sorted.index(custo_beneficio[i])
			profits_sorted[i] = @profits[index]
			weights_sorted[i] = @weights[index]
		end

		@weights = weights_sorted
		@profits = profits_sorted

		#initial settings
		_S = Array.new
		_PI = 0

		combinations = Array.new
		for i in 1..$K do 
			combinations = combinations + Array(0..@size).combination(i).to_a
		end

		puts combinations[0..50]

	end	
end

problems = Array.new
entries =  Dir.glob('*.txt')
entries.each do |filename|
	File.open(filename, 'r+') do |file|
		plaintext = file.read
		plaintext = plaintext.split("\r\n")
		problems << Knapsack.new(plaintext[0].to_i, 
					plaintext[1].split(" ").collect{|x| x = x.to_i}, 
					plaintext[2].split(" ").collect{|x| x = x.to_i},
					plaintext[3].to_i)
	end
end

#problems.each do |problem|
	#problem.optimal_heuristic
	#problem.sahni_heuristic
#end

problems[0].sahni_heuristic