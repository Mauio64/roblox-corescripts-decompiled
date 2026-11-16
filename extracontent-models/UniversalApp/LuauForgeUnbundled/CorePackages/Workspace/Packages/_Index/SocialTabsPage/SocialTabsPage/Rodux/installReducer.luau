local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialTabsPage/Rodux")
local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Index/SocialTabsPage/SocialTabsPage/Networking/myRoduxNetworking")

return function()
	return Rodux.combineReducers({ NetworkStatus = myRoduxNetworking.installReducer() })
end
