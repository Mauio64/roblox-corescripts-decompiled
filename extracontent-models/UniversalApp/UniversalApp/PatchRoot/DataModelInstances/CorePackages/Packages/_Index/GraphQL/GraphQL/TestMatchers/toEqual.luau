local deepEqual = require(script.Parent.Parent.luaUtils.deepEqual)

local function toEqual(p, p2)
	local pass, v = deepEqual(p, p2)
	local message

	if pass then
		message = ("expected: not %s\nreceived:     %s"):format(tostring(p2), (tostring(p)))
	else
		message = v:gsub("{1}", "received"):gsub("{2}", "expected")
	end

	return { pass = pass, message = message }
end

return toEqual
