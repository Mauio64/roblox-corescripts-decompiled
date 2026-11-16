local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local LuauPolyfill = require(parent2.LuauPolyfill)
local Error = LuauPolyfill.Error

require(parent.luaUtils.Response)

return {
	throwServerError = function(response, p, p2: string)
		local v = Error.new(p2)
		v.name = "ServerError"
		v.response = response
		v.statusCode = response.status
		v.result = p
		error(v)
	end
}
