local parent = script:FindFirstAncestor("VirtualEvents").Parent

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local Http = require(parent.Http)
local Url = Http.Url
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiCapabilities = SduiSharedUtilities.SduiCapabilities
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiCapabilityBindings = SharedFlags.FFlagSduiCapabilityBindings

local v = urlBuilder.new({ base = Url.APIS_URL, path = "virtual-events/v1beta1/event-details-page" })

local function getEventDetailsUrl(eventId: string)
	local v2 = { eventId = eventId }

	if FFlagSduiCapabilityBindings then
		require(parent.ServiceContractsProto)

		SduiCapabilities.addToQueryParams(v2, { "CAPABILITY_SUPPORTS_EVENT_RSVP_FACE_PILE" })
	end

	return urlBuilder.addQueryString(v(), v2)
end

return getEventDetailsUrl
