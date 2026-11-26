local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/Rodux")
local ProfileRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Networking/ProfileRoduxNetworking")

return function()
	return Rodux.combineReducers({ NetworkStatus = ProfileRoduxNetworking.installReducer() })
end
