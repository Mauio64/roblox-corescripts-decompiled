local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEventsState/Rodux")
local roduxNetworking = require("@game/CorePackages/Workspace/Packages/_Index/VirtualEventsState/VirtualEventsState/network").RoduxNetworking

local function installReducer()
	return Rodux.combineReducers({
		networkStatus = roduxNetworking.installReducer(),
		events = require("@game/CorePackages/Workspace/Packages/_Index/VirtualEventsState/VirtualEventsState/Reducers/events"),
		media = require("@game/CorePackages/Workspace/Packages/_Index/VirtualEventsState/VirtualEventsState/Reducers/experienceDetails"),
		experienceDetails = require("@game/CorePackages/Workspace/Packages/_Index/VirtualEventsState/VirtualEventsState/Reducers/media"),
		rsvps = require("@game/CorePackages/Workspace/Packages/_Index/VirtualEventsState/VirtualEventsState/Reducers/rsvps")
	})
end

return installReducer
