local VirtualEventsState = script:FindFirstAncestor("VirtualEventsState")

local Rodux = require(VirtualEventsState.Parent.Rodux)
local network = require(VirtualEventsState.network)
local roduxNetworking = network.RoduxNetworking

local function installReducer()
	return Rodux.combineReducers({
		networkStatus = roduxNetworking.installReducer(),
		events = require(VirtualEventsState.Reducers.events),
		media = require(VirtualEventsState.Reducers.media),
		experienceDetails = require(VirtualEventsState.Reducers.experienceDetails),
		rsvps = require(VirtualEventsState.Reducers.rsvps)
	})
end

return installReducer
