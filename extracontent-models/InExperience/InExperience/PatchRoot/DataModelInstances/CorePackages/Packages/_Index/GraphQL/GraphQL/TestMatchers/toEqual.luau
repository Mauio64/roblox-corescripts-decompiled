local deepEqual = require(script.Parent.Parent.luaUtils.deepEqual)

local function toEqual(p1, p2) -- line: 17
	-- upvalues: deepEqual (copy)
	local v5, v6 = deepEqual(p1, p2)
	local v7 = if v5 then ("expected: not %s\nreceived:     %s"):format(tostring(p2), (tostring(p1))) else v6:gsub("{1}", "received"):gsub("{2}", "expected")

	return {
		pass = v5,
		message = v7
	}
end

return toEqual
