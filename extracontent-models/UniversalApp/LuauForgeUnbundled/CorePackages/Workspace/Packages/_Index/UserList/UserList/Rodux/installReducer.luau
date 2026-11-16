local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Rodux")
local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Networking/myRoduxNetworking")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Rodux/Presence")
local FFlagUserListPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Flags/FFlagUserListPresenceStoreMigration")

return function()
	return Rodux.combineReducers({
		Presence = if not FFlagUserListPresenceStoreMigration then module3 else nil,
		NetworkStatus = myRoduxNetworking.installReducer()
	})
end
