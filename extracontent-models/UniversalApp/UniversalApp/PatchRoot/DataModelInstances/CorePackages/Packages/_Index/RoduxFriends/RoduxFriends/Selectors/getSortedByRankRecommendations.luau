local parent = script.Parent.Parent
local parent2 = parent.Parent

local llama = require(parent2.llama)
require(parent.roduxFriendsTypes)
local getDeepValue = require(parent.getDeepValue)

local function fn(p, p2): boolean
	return p.rank < p2.rank
end

return function(p)
	local keyPath = p.keyPath
	return function(p2, p3)
		local v = getDeepValue(p2, string.format("%s.recommendations.byUserId.%s", keyPath, p3)) or {}

		return llama.List.sort(llama.Dictionary.values(v), fn)
	end
end
