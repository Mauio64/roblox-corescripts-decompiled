local url = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Http").Url
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/UrlBuilder").UrlBuilder
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/SduiSharedUtilities")
local fFlagSduiAllowNoConfigsBuilt = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/SharedFlags").FFlagSduiAllowNoConfigsBuilt

local ContentPageConstants = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/ContentPage/ContentPageConstants")

local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local sduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local sduiResponseType = SduiSharedUtilities.SduiResponseType
local sduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
local sduiCapabilities = SduiSharedUtilities.SduiCapabilities

local configKey = ContentPageConstants.ConfigKey

local v5 = urlBuilder.new({ base = url.NOTIFICATION_URL, path = ContentPageConstants.ApiPath })

local function fetchStreamNotificationsContentPage(p2)
	local stream_page = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/ServiceContractsProto").apppageplatform.notifications.stream_page
	local clientCapabilities = sduiCapabilities.buildClientCapabilities()

	return getSduiApiStore().fetchIfNeeded({
		responseType = sduiResponseType.Protobuf,
		url = v5(),
		surfaceKey = configKey,
		configKey = configKey,
		clearOnEmptyResponse = true,
		replaceOnFetch = true,
		allowNoConfigsBuilt = fFlagSduiAllowNoConfigsBuilt and true or nil,
		loadTimer = sduiLoadTimer.createLoadTimer(configKey),
		apiProto = stream_page.StreamPageResponse,
		postConfig = {
			contentType = sduiApiStorePostConfigContentType.Proto,
			protoMessage = stream_page.StreamPageRequest,
			body = stream_page.StreamPageRequest.new({
				client_capabilities = clientCapabilities,
				client_attributes = p2
			})
		}
	}, true)
end

return fetchStreamNotificationsContentPage
