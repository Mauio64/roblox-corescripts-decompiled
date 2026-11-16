local parent = script.Parent.Parent
local parent2 = parent.Parent
require(parent2.LuauPolyfill)

local Promise = require(parent2.Promise)
require(parent.jsutils.PromiseOrValue)

return {
	coerceToPromise = function(p)
		if Promise.is(p) then
			return p
		end

		return (Promise.resolve(p))
	end
}
