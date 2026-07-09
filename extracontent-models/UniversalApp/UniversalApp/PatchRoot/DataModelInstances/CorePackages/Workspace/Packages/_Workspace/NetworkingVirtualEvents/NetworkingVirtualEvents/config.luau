local NetworkingVirtualEvents = script:FindFirstAncestor("NetworkingVirtualEvents")
local createCreateVirtualEvent = require(NetworkingVirtualEvents.requests.createCreateVirtualEvent)
local createUpdateVirtualEvent = require(NetworkingVirtualEvents.requests.createUpdateVirtualEvent)
local createDeleteVirtualEvent = require(NetworkingVirtualEvents.requests.createDeleteVirtualEvent)
local createGetVirtualEvent = require(NetworkingVirtualEvents.requests.createGetVirtualEvent)
local createGetMyVirtualEvents = require(NetworkingVirtualEvents.requests.createGetMyVirtualEvents)
local createGetActiveVirtualEvents = require(NetworkingVirtualEvents.requests.createGetActiveVirtualEvents)
local createGetVirtualEventRsvps = require(NetworkingVirtualEvents.requests.createGetVirtualEventRsvps)
local createUpdateMyRsvpStatus = require(NetworkingVirtualEvents.requests.createUpdateMyRsvpStatus)
local createGetVirtualEventRsvpCounts = require(NetworkingVirtualEvents.requests.createGetVirtualEventRsvpCounts)

require(NetworkingVirtualEvents.types)

return function(p1) -- line: 14
	-- upvalues: createCreateVirtualEvent (copy), createUpdateVirtualEvent (copy), createDeleteVirtualEvent (copy), createGetVirtualEvent (copy), createGetMyVirtualEvents (copy), createGetActiveVirtualEvents (copy), createGetVirtualEventRsvps (copy), createUpdateMyRsvpStatus (copy), createGetVirtualEventRsvpCounts (copy), NetworkingVirtualEvents (copy)
	local roduxNetworking = p1.roduxNetworking

	return {
		CreateVirtualEvent = createCreateVirtualEvent(roduxNetworking),
		UpdateVirtualEvent = createUpdateVirtualEvent(roduxNetworking),
		DeleteVirtualEvent = createDeleteVirtualEvent(roduxNetworking),
		GetVirtualEvent = createGetVirtualEvent(roduxNetworking),
		GetMyVirtualEvents = createGetMyVirtualEvents(roduxNetworking),
		GetActiveVirtualEvents = createGetActiveVirtualEvents(roduxNetworking),
		GetVirtualEventRsvps = createGetVirtualEventRsvps(roduxNetworking),
		UpdateMyRsvpStatus = createUpdateMyRsvpStatus(roduxNetworking),
		GetVirtualEventRsvpCounts = createGetVirtualEventRsvpCounts(roduxNetworking),
		VirtualEventModel = require(NetworkingVirtualEvents.models.VirtualEventModel),
		createMockVirtualEventResponse = require(NetworkingVirtualEvents.createMockVirtualEventResponse)
	}
end
