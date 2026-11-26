local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/Rodux")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Rodux/Presence")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Rodux/Friends")
local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Networking/myRoduxNetworking")

local FFlagUserSearchPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Flags/FFlagUserSearchPresenceStoreMigration")

return function()
	return Rodux.combineReducers({
		Presence = if not FFlagUserSearchPresenceStoreMigration then module2 else nil,
		NetworkStatus = myRoduxNetworking.installReducer(),
		Friends = module3
	})
end
