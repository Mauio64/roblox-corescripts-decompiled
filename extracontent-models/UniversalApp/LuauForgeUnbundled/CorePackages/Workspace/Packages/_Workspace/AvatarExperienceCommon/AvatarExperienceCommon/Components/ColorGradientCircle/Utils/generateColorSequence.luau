local function deduplicateBodyColor3s(items)
	local set = {}
	local result = {}

	for k, item in items do
		local v5 = tostring(item)

		if set[v5] then
			continue
		end

		table.insert(result, item)
		set[v5] = true
	end

	return result
end

local function generateColorSequence(p2)
	local v5 = deduplicateBodyColor3s(p2)
	local count = #v5

	if count == 1 then
		local v6 = v5[1]
		return ColorSequence.new(v6, v6)
	end

	local v6 = 1 / (count - 1 + 1.6)
	local colorSequenceKeypoints = {}

	for k, v7 in v5 do
		local v8 = k == 1 and 0 or k == count and 1 or (k - 1 + 0.8) * v6

		table.insert(colorSequenceKeypoints, ColorSequenceKeypoint.new(v8, v7))
	end

	return ColorSequence.new(colorSequenceKeypoints)
end

return generateColorSequence
