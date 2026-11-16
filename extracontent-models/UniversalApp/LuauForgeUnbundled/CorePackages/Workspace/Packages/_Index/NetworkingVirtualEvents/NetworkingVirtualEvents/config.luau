local createCreateVirtualEvent = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingVirtualEvents/NetworkingVirtualEvents/requests/createCreateVirtualEvent")
local createUpdateVirtualEvent = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingVirtualEvents/NetworkingVirtualEvents/requests/createUpdateVirtualEvent")
local createDeleteVirtualEvent = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingVirtualEvents/NetworkingVirtualEvents/requests/createDeleteVirtualEvent")
local createGetVirtualEvent = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingVirtualEvents/NetworkingVirtualEvents/requests/createGetVirtualEvent")
local createGetMyVirtualEvents = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingVirtualEvents/NetworkingVirtualEvents/requests/createGetMyVirtualEvents")
local createGetActiveVirtualEvents = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingVirtualEvents/NetworkingVirtualEvents/requests/createGetActiveVirtualEvents")
local createGetVirtualEventRsvps = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingVirtualEvents/NetworkingVirtualEvents/requests/createGetVirtualEventRsvps")
local createUpdateMyRsvpStatus = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingVirtualEvents/NetworkingVirtualEvents/requests/createUpdateMyRsvpStatus")
local createGetVirtualEventRsvpCounts = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingVirtualEvents/NetworkingVirtualEvents/requests/createGetVirtualEventRsvpCounts")
require("@game/CorePackages/Workspace/Packages/_Index/NetworkingVirtualEvents/NetworkingVirtualEvents/types")

return function(p2)
	local roduxNetworking = p2.roduxNetworking

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
		VirtualEventModel = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingVirtualEvents/NetworkingVirtualEvents/models/VirtualEventModel"),
		createMockVirtualEventResponse = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingVirtualEvents/NetworkingVirtualEvents/createMockVirtualEventResponse")
	}
end
