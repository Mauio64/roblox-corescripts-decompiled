require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")
local selectRecommendationsForUserId = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Selectors/selectRecommendationsForUserId")
local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/LuauPolyfill")
local object = LuauPolyfill.Object
local array = LuauPolyfill.Array

local function fn(p2, p3)
	return (p2.rank or 0) - (p3.rank or 0)
end

return function(p2)
	return function(p3)
		return function(p4, p5)
			local v5 = selectRecommendationsForUserId(p2)(p3)(p4, p5)

			return array.map(array.sort(object.values(v5), fn), function(p6)
				return p6.id
			end)
		end
	end
end
