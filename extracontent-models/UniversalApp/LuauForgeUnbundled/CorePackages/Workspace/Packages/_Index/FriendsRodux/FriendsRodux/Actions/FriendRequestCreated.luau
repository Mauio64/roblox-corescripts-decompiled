local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")

return Rodux.makeActionCreator("FriendRequestCreated", function(p2)
	return p2
end)
