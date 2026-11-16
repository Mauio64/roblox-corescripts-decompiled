local function deduplicateBodyColor3s(items)
	local set = {}
	local result = {}

	for _, item in items do
		local v = tostring(item)

		if set[v] then
			continue
		end

		table.insert(result, item)
		set[v] = true
	end

	return result
end

local function generateColorSequence(p)
	local v = deduplicateBodyColor3s(p)
	local count = #v

	if count == 1 then
		local v2 = v[1]
		return ColorSequence.new(v2, v2)
	end

	local v2 = 1 / (count - 1 + 1.6)
	local colorSequenceKeypoints = {}

	for k, v3 in v do
		local v4 = k == 1 and 0 or k == count and 1 or (k - 1 + 0.8) * v2

		table.insert(colorSequenceKeypoints, ColorSequenceKeypoint.new(v4, v3))
	end

	return ColorSequence.new(colorSequenceKeypoints)
end

return generateColorSequence
