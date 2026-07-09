local t1 = {}

t1.__index = t1

function t1.new(n1: number) -- line: 20
	-- upvalues: t1 (copy)
	return (setmetatable({
		levels = { table.create(n1) },
		weightedSketch = {
			totalWeight = 0,
			cached = false,
			weightTuples = {}
		},
		maxSize = if n1 % 2 ~= 0 then n1 - 1 else n1
	}, t1))
end
function t1.insert(t2: {[any]: any}, n2: number) -- line: 36
	t2.weightedSketch.cached = false

	local levels = t2.levels

	table.insert(levels[1], n2)

	for v6, v7 in levels do
		if #v7 >= t2.maxSize then
			compressWeightedKll(levels, v6)
		end
	end
end
function compressWeightedKll(t3: {[any]: any}, n3: number) -- line: 51
	local v10 = t3[n3]

	table.sort(v10)

	local t4 = table.create(#v10 // 2)

	for i = 1, #v10, 2 do
		table.insert(t4, v10[math.random(2) - 1 + i])
	end

	if n3 == #t3 then
		table.insert(t3, t4)
	else
		table.move(t4, 1, #t4, #t3[n3 + 1] + 1, t3[n3 + 1])
	end

	table.clear(t3[n3])
end
function t1.generateWeightedSketch(p1) -- line: 77
	local t5 = {}
	local n4 = 1
	local n5 = 0

	for _, v18 in p1.levels do
		for _, v20 in v18 do
			table.insert(t5, {
				value = v20,
				weight = n4
			})
			n5 += n4
		end

		n4 *= 2
	end

	table.sort(t5, function(p2, p3) -- line: 94
		return p2.value < p3.value
	end)
	p1.weightedSketch = {
		cached = true,
		weightTuples = t5,
		totalWeight = n5
	}
end
function t1.getPercentile(t6: {[any]: any}, n6: number) -- line: 106
	if not t6.weightedSketch.cached then
		t6:generateWeightedSketch()
	end

	if #t6.weightedSketch.weightTuples > 0 then
		local v23 = math.floor(n6 / 100 * t6.weightedSketch.totalWeight)
		local n7 = 0

		for _, v26 in t6.weightedSketch.weightTuples do
			n7 += v26.weight

			if v23 <= n7 then
				return v26.value
			end
		end
	end

	return 0
end

return t1
