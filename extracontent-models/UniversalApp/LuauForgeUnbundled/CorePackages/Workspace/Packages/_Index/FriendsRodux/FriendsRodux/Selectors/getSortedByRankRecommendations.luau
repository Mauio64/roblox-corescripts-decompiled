local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/llama")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")
local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/getDeepValue")

local function fn(p2, p3): boolean
	return p2.rank < p3.rank
end

return function(p2)
	local keyPath = p2.keyPath
	return function(p3, p4)
		local v5 = getDeepValue(p3, string.format("%s.recommendations.byUserId.%s", keyPath, p4)) or {}

		return llama.List.sort(llama.Dictionary.values(v5), fn)
	end
end
