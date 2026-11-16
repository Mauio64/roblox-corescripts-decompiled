local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UrlBuilder").UrlBuilder
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Http").Url
local sduiCapabilities = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/SduiSharedUtilities").SduiCapabilities
local fFlagSduiCapabilityBindings = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/SharedFlags").FFlagSduiCapabilityBindings

local v5 = urlBuilder.new({
	base = url.APIS_URL,
	path = "virtual-events/v1beta1/event-details-page"
})

local function getEventDetailsUrl(p2)
	local v6 = { eventId = p2 }

	if fFlagSduiCapabilityBindings then
		require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/ServiceContractsProto")

		sduiCapabilities.addToQueryParams(v6, { "CAPABILITY_SUPPORTS_EVENT_RSVP_FACE_PILE" })
	end

	return urlBuilder.addQueryString(v5(), v6)
end

return getEventDetailsUrl
