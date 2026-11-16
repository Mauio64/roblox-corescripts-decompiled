local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")

return Rodux.makeActionCreator("FriendshipCreated", function(p2, p3)
	return {
		payload = { userId1 = p2, userId2 = p3 }
	}
end)
