local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/llama")

local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/getDeepValue")

return function(p2)
	local keyPath = p2.keyPath
	return function(p3, p4, p5)
		local v5 = getDeepValue(p3, keyPath .. ".byUserId")
		return v5[p4] ~= nil and llama.List.find(v5[p4], p5) and true or false
	end
end
