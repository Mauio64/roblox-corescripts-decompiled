local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/Rodux")

local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Index/SocialBlockingModal/SocialBlockingModal/Networking/myRoduxNetworking")

return function()
	return Rodux.combineReducers({ NetworkStatus = myRoduxNetworking.installReducer() })
end
