local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/followings/followingStatuses")

return function(p2)
	return Rodux.combineReducers({ followingStatuses = module2(p2) })
end
