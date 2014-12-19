$K = 4

class Knapsack
	def initialize size, profits, weights, capacity, filename
		@size = size
		@profits = profits
		@weights = weights
		@capacity = capacity
		@output = File.new('results', 'a+')
		@name = filename

	end

	def output_header
		@output.puts "\n\n---------------------PROBLEM #{@name} -------
		--------------------"
	end

	def optimal_heuristic
		#initializes the main matrix
		@DP_matrix = Array.new(@size+1)
		.collect{|e| e = Array.new(@capacity+1, -1)}

		#fills the first row/col with zeros
		@DP_matrix[0].collect!{|e| e = 0}
		for i in 0..@size
			@DP_matrix[i][0] = 0
		end

		#fills the matrix
		for i in 1..@size
			for w in 1..@capacity
				if(w < @weights[i-1])
					@DP_matrix[i][w] = @DP_matrix[i-1][w]
				else
					@DP_matrix[i][w] = [@DP_matrix[i-1][w], @profits[i-1] \
					+ @DP_matrix[i-1][w - @weights[i-1]]].max
				end
			end
		end

		items = Array.new

		i = @size
		k = @capacity
		while i >= 0 && k >= 0
			if(@DP_matrix[i][k] != @DP_matrix[i-1][k])
				items << i
				k -= @weights[i-1]
			end
				i -= 1
		end

		total_weight = 0
		items.each do |i|
				total_weight += @weights[i-1]
			end

		#sometimes a last item is added for no known reason. we are sorry
		if total_weight > @capacity
			@output.puts "################## OPTIMAL HEURISTIC ###################"
			@output.puts "problem size: #{@size}"
			@output.puts "Total profit: #{@DP_matrix.last.last}"
			@output.print "items: {"
			items[0..-2].each do |i|
				@output.print "(p: #{@profits[i-1]}, w: #{@weights[i-1]}) "
			end
			@output.puts "}"
			@output.puts "knapsack weight: #{total_weight - @weights[items.last]}
			(max capacity: #{@capacity})"
			@output.puts "#########################################################"
		else
			@output.puts "################## OPTIMAL HEURISTIC ###################"
			@output.puts "problem size: #{@size}"
			@output.puts "Total profit: #{@DP_matrix.last.last}"
			@output.print "items: {"
			items[0..-2].each do |i|
				@output.print "(p: #{@profits[i-1]}, w: #{@weights[i-1]}) "
			end
			@output.puts "}"
			@output.puts "knapsack weight: #{total_weight} (max capacity: #{@capacity})"
			@output.puts "#########################################################"
		end
	end

	def sahni_heuristic
		#sorts the profits/weights arrays in
		#non-incresing order for ratio profit/weight
		custo_beneficio = Array.new(@size)
		@size.times do |i|
			custo_beneficio[i] = @profits[i].to_f / @weights[i]
		end

		custo_beneficio_sorted = custo_beneficio.sort

		profits_sorted = Array.new
		weights_sorted = Array.new
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

		#gets all the combinations up to k elements
		combinations = Array.new
		for i in 1..$K do
			combinations = combinations + Array(0..@size-1).combination(i).to_a
		end

		#for each combination, gets its total profit and weight
		combinations.each do |combination|
			combination_w_sum = 0
			combination_p_sum = 0
			combination.each do |i|
				combination_p_sum += @profits[i]
				combination_w_sum += @weights[i]
			end
			#if total w doesnt exceed capacity, applies GREEDY
			if combination_w_sum <= @capacity
				remaining_capacity = @capacity - combination_w_sum
				j = 0
				_T_S = Array.new
				_T_PI = 0

				while j < @size && remaining_capacity > 0
					#ignores elements in the combination
					if @weights[j] <= remaining_capacity && combination.index(j).nil?
						_T_S << j
						_T_PI += @profits[j]
						remaining_capacity -= @weights[j]
					end
					j += 1
					#if the found sum is higher than the current max
					#sum, then saves it
					if combination_p_sum + _T_PI > _PI
						_PI = combination_p_sum + _T_PI
						_S = combination + _T_S
					end
				end
			end

		end

		@output.puts "#################### SAHNI HEURISTIC ####################"
		@output.puts "problem size: #{@size}"
		@output.puts "total profit: #{_PI}"
		@output.print "items: {"
		result = 0
		_S.each do |i|
			result += @weights[i]
			@output.print "(p: #{@profits[i]}, w: #{@weights[i]}) "
		end
		@output.puts "}\ntotal weight: #{result} (max capacity: #{@capacity})"

		@output.puts "##########################################################"
	end
end


problems = Array.new
#=begin
entries =  Dir.glob('*.txt')
entries.each do |filename|
	File.open(filename, 'r+') do |file|
		plaintext = file.read
		plaintext = plaintext.split("\r\n")
		problems << Knapsack.new(plaintext[0].to_i,
					plaintext[1].split(" ").collect{|x| x = x.to_i},
					plaintext[2].split(" ").collect{|x| x = x.to_i},
					plaintext[3].to_i,
					filename)
	end
end

#f = File.new('benchmarks', 'w')

#f.puts "times for optimal_heuristic:"
problems.each_with_index do |problem, i|
	time = Time.now
	problem.output_header
	problem.optimal_heuristic
#	f.puts "#{Time.now - time}"
end

$K = 3
#f.puts "times for sahni_heuristic with k=#{$K}"
problems.each_with_index do |problem, i|
	time = Time.now
	problem.output_header
	problem.sahni_heuristic
#	f.puts "#{Time.new - time}"
end
