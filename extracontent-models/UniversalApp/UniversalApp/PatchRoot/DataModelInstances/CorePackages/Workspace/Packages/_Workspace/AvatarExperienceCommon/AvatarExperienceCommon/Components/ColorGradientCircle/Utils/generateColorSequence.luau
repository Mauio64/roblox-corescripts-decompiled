local function deduplicateBodyColor3s(t1: {[any]: any}) -- line: 5
	local t2 = {}
	local t3 = {}

	for _, v7 in t1 do
		local str = tostring(v7)

		if not t3[str] then
			table.insert(t2, v7)
			t3[str] = true
		end
	end

	return t2
end
local function generateColorSequence(t4: {[any]: any}) -- line: 23
	-- upvalues: deduplicateBodyColor3s (copy)
	local v10 = deduplicateBodyColor3s(t4)
	local v11 = #v10

	if v11 == 1 then
		local v12 = v10[1]

		return ColorSequence.new(v12, v12)
	end

	local t5 = {}
	local v14 = 1 / (v11 - 1 + 1.6)

	for v15, v16 in v10 do
		local v17 = if v15 ~= 1 then if v15 ~= v11 then (v15 - 1 + 0.8) * v14 else 1 else 0

		table.insert(t5, ColorSequenceKeypoint.new(v17, v16))
	end

	return ColorSequence.new(t5)
end

return generateColorSequence
