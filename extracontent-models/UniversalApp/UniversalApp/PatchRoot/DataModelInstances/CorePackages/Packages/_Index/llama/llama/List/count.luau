local function alwaysTrue() -- line: 2
	return true
end
local function count(p1, p2) -- line: 6
	-- upvalues: alwaysTrue (copy)
	local v5 = type(p1)

	assert(v5 == "table", "expected a table for first argument, got " .. v5)

	local v6 = p2 or alwaysTrue
	local n1 = 0

	for i = 1, #p1 do
		if v6(p1[i], i) then
			n1 += 1
		end
	end

	return n1
end

return count
