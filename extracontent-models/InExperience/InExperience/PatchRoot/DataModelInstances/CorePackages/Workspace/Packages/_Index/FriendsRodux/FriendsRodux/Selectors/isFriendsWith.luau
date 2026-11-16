local parent = script.Parent.Parent
local parent2 = script:FindFirstAncestor("FriendsRodux").Parent
local llama = require(parent2.llama)

local getDeepValue = require(parent.getDeepValue)

return function(p)
	local keyPath = p.keyPath
	return function(p2, p3, p4)
		local deepValue = getDeepValue(p2, keyPath .. ".byUserId")
		return deepValue[p3] ~= nil and llama.List.find(deepValue[p3], p4) and true or false
	end
end
