local function alwaysTrue() -- line: 2
	return true
end
local function count(p1, p2) -- line: 6
	-- upvalues: alwaysTrue (copy)
	local v5 = type(p1)

	assert(v5 == "table", "expected a table for first argument, got " .. v5)

	local n1 = 0
	local v7 = p2 or alwaysTrue

	for k, v in pairs(p1) do
		if v7(v, k) then
			n1 += 1
		end
	end

	return n1
end

return count
