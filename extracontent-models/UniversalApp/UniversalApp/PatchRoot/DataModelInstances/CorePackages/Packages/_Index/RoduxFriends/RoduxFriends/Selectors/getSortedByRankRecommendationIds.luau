local parent = script.Parent.Parent
local parent2 = parent.Parent

require(parent.roduxFriendsTypes)
local selectRecommendationsForUserId = require(script.Parent.selectRecommendationsForUserId)
local LuauPolyfill = require(parent2.LuauPolyfill)
local Object = LuauPolyfill.Object
local Array = LuauPolyfill.Array

local function fn(p, p2)
	return (p.rank or 0) - (p2.rank or 0)
end

return function(p)
	return function(p2)
		return function(p3: string, p4)
			local v = selectRecommendationsForUserId(p)(p2)(p3, p4)

			return Array.map(Array.sort(Object.values(v), fn), function(p5)
				return p5.id
			end)
		end
	end
end
