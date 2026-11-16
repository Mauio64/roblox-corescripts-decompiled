local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/getDeepValue")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")
local object = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/LuauPolyfill").Object

return function(p2)
	local keyPath = p2.keyPath
	return function(p3)
		return function(value)
			local v5 = getDeepValue(p3, string.format("%s.recommendations.bySource.%s", keyPath, value or ""))
				or {}

			return object.keys(v5)
		end
	end
end
