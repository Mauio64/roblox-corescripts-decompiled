local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Rodux")
local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Networking/myRoduxNetworking")

return function()
	return Rodux.combineReducers({ NetworkStatus = myRoduxNetworking.installReducer() })
end
