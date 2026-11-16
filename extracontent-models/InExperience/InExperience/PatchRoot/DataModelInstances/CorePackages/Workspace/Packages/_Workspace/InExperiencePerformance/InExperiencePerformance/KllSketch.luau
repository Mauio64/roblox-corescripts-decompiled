local KllSketch = {}
KllSketch.__index = KllSketch

function KllSketch.new(maxSize: number)
	local v = {
		levels = { table.create(maxSize) },
		weightedSketch = { weightTuples = {}, totalWeight = 0, cached = false },
		maxSize = 0
	}

	if maxSize % 2 ~= 0 then
		maxSize -= 1
	end

	v.maxSize = maxSize

	return (setmetatable(v, KllSketch))
end

function KllSketch.insert(data, p: number)
	data.weightedSketch.cached = false

	local levels = data.levels
	table.insert(levels[1], p)

	for k, level in levels do
		if #level >= data.maxSize then
			compressWeightedKll(levels, k)
		end
	end
end

function compressWeightedKll(list, p: number)
	local item = list[p]
	table.sort(item)

	local v = table.create(#item // 2)

	for i = 1, #item, 2 do
		table.insert(v, item[math.random(2) - 1 + i])
	end

	if p == #list then
		table.insert(list, v)
	else
		table.move(v, 1, #v, #list[p + 1] + 1, list[p + 1])
	end

	table.clear(list[p])
end

function KllSketch:generateWeightedSketch()
	local weight = 1
	local weightTuples = {}
	local total = 0

	for _, level in self.levels do
		for _, v in level do
			table.insert(weightTuples, { value = v, weight = weight })

			total += weight
		end

		weight *= 2
	end

	table.sort(weightTuples, function(a, b): boolean
		return a.value < b.value
	end)

	self.weightedSketch = { weightTuples = weightTuples, totalWeight = total, cached = true }
end

function KllSketch:getPercentile(p: number)
	if not self.weightedSketch.cached then
		self:generateWeightedSketch()
	end

	if #self.weightedSketch.weightTuples > 0 then
		local v = math.floor(p / 100 * self.weightedSketch.totalWeight)
		local total = 0

		for _, weightTuple in self.weightedSketch.weightTuples do
			total += weightTuple.weight

			if v <= total then
				return weightTuple.value
			end
		end
	end

	return 0
end

return KllSketch
