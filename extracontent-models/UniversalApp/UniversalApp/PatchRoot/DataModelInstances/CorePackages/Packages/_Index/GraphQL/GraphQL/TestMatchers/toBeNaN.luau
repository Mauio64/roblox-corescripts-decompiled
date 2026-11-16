local LuauPolyfill = require(script.Parent.Parent.Parent.LuauPolyfill)
local Number = LuauPolyfill.Number

local function toBeNaN(p)
	local naN = Number.isNaN(p)

	if naN then
		return { pass = naN }
	end

	return {
		pass = false,
		message = ("expected: NaN (number), got: \"%s\" (%s) instead"):format(tostring(p), (typeof(p)))
	}
end

return toBeNaN
