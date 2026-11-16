local parent = script:FindFirstAncestor("StreamNotifications").Parent

local Http = require(parent.Http)
local Url = Http.Url
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiAllowNoConfigsBuilt = SharedFlags.FFlagSduiAllowNoConfigsBuilt

local ContentPageConstants = require(script.Parent.ContentPageConstants)

local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local SduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
local SduiCapabilities = SduiSharedUtilities.SduiCapabilities

local ConfigKey = ContentPageConstants.ConfigKey

local v = urlBuilder.new({ base = Url.NOTIFICATION_URL, path = ContentPageConstants.ApiPath })

local function fetchStreamNotificationsContentPage(client_attributes)
	local ServiceContractsProto = require(parent.ServiceContractsProto)
	local stream_page = ServiceContractsProto.apppageplatform.notifications.stream_page
	local clientCapabilities = SduiCapabilities.buildClientCapabilities()

	return getSduiApiStore().fetchIfNeeded({
		responseType = SduiResponseType.Protobuf,
		url = v(),
		surfaceKey = ConfigKey,
		configKey = ConfigKey,
		clearOnEmptyResponse = true,
		replaceOnFetch = true,
		allowNoConfigsBuilt = FFlagSduiAllowNoConfigsBuilt and true or nil,
		loadTimer = SduiLoadTimer.createLoadTimer(ConfigKey),
		apiProto = stream_page.StreamPageResponse,
		postConfig = {
			contentType = SduiApiStorePostConfigContentType.Proto,
			protoMessage = stream_page.StreamPageRequest,
			body = stream_page.StreamPageRequest.new({
				client_capabilities = clientCapabilities,
				client_attributes = client_attributes
			})
		}
	}, true)
end

return fetchStreamNotificationsContentPage
