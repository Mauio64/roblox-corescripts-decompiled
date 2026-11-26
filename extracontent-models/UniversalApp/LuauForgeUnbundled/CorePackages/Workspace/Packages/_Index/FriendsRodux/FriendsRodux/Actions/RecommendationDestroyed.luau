local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")
require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")

return Rodux.makeActionCreator("RecommendationDestroyed", function(p2)
	return { payload = p2 }
end)
