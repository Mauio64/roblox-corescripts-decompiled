local Number = require(script.Parent.Parent.Parent.LuauPolyfill).Number

local function toBeNaN(p1) -- line: 17
	-- upvalues: Number (copy)
	local v4 = Number.isNaN(p1)

	if v4 then
		return {
			pass = v4
		}
	end

	return {
		pass = false,
		message = ("expected: NaN (number), got: \"%s\" (%s) instead"):format(tostring(p1), (typeof(p1)))
	}
end

return toBeNaN
