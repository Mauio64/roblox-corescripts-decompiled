local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Rodux")
local ProfileRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Networking/ProfileRoduxNetworking")

return function()
	return Rodux.combineReducers({ NetworkStatus = ProfileRoduxNetworking.installReducer() })
end
