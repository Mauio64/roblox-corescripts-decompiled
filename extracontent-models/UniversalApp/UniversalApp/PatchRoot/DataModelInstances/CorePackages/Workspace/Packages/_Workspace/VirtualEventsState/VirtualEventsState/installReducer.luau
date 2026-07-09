local VirtualEventsState = script:FindFirstAncestor("VirtualEventsState")
local Rodux = require(VirtualEventsState.Parent.Rodux)
local RoduxNetworking = require(VirtualEventsState.network).RoduxNetworking

local function installReducer() -- line: 7
	-- upvalues: Rodux (copy), RoduxNetworking (copy), VirtualEventsState (copy)
	return Rodux.combineReducers({
		networkStatus = RoduxNetworking.installReducer(),
		events = require(VirtualEventsState.Reducers.events),
		media = require(VirtualEventsState.Reducers.media),
		experienceDetails = require(VirtualEventsState.Reducers.experienceDetails),
		rsvps = require(VirtualEventsState.Reducers.rsvps)
	})
end

return installReducer
