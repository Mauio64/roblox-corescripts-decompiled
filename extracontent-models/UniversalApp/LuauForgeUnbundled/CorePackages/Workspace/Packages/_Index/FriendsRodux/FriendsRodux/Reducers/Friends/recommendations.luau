local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/recommendations/byUserId")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/recommendations/bySource")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/recommendations/hasIncomingFriendRequest")

return function(p2)
	return Rodux.combineReducers({
		byUserId = module2(p2),
		bySource = module3(p2),
		hasIncomingFriendRequest = module4(p2)
	})
end
