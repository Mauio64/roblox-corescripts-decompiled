local parent = script.Parent.Parent
local parent2 = parent.Parent

local getDeepValue = require(parent.getDeepValue)
require(parent.roduxFriendsTypes)
local LuauPolyfill = require(parent2.LuauPolyfill)
local Object = LuauPolyfill.Object

return function(p)
	local keyPath = p.keyPath
	return function(p2)
		return function(value: string)
			local v = getDeepValue(p2, string.format("%s.recommendations.bySource.%s", keyPath, value or "")) or {}

			return Object.keys(v)
		end
	end
end
