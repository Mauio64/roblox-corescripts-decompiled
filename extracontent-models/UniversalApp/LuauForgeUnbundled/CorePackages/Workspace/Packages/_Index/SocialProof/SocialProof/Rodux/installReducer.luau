local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/Rodux")
local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Index/SocialProof/SocialProof/Networking/myRoduxNetworking")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/SocialProof/SocialProof/Rodux/ConnectionsByEntityId")

return function()
	return Rodux.combineReducers({
		NetworkStatus = myRoduxNetworking.installReducer(),
		ConnectionsByEntityId = module3
	})
end
