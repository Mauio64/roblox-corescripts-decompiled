local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/Rodux")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Rodux/UserBlocking")

local FFlagUserBlockingApiPlayerContextMenuEnabled = require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Flags/FFlagUserBlockingApiPlayerContextMenuEnabled")

return function()
	local combineReducers = Rodux.combineReducers

	local v6 = if not FFlagUserBlockingApiPlayerContextMenuEnabled then require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Reducers/IsBlockedByMe") else nil

	local v7 = if FFlagUserBlockingApiPlayerContextMenuEnabled then module2.installReducer() else nil
	return combineReducers({ IsBlockedByMe = v6, UserBlocking = v7 })
end
