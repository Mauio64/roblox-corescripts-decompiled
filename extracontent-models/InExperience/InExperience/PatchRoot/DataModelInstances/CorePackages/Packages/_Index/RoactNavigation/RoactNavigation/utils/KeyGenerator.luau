local u1 = "id-" .. tostring(math.random(100000, 1000000))
local n1 = 0

return {
	_TESTING_ONLY_normalize_keys = function() -- line: 9
		-- upvalues: u1 (ref), n1 (ref)
		u1 = "id-"
		n1 = 0
	end,
	generateKey = function() -- line: 15
		-- upvalues: u1 (ref), n1 (ref)
		local v3 = u1 .. tostring(n1)

		n1 += 1

		return v3
	end
}
