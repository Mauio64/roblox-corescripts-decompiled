local appPage = require("@luauforge/deferred/hQm").AppPage
local module = require("@luauforge/deferred/hQp")
local sduiResponseType = module.SduiResponseType
local getSduiApiStore = module.getSduiApiStore

local module2 = require("@luauforge/deferred/hQs")
local module3 = require("@luauforge/deferred/hQt")

local fFlagSduiExtendedCapabilitiesDiscovery = require("@luauforge/deferred/hQw").FFlagSduiExtendedCapabilitiesDiscovery

local function fetchSduiLandingPage(p2, p3, p4, p5)
	if fFlagSduiExtendedCapabilitiesDiscovery then
		local v5 = module2(p2)

		local spotlight_collection_page = require("@luauforge/deferred/hQx").apppageplatform.spotlightcollection.spotlight_collection_page
		local module4 = require("@luauforge/deferred/hQy")
		local sduiApiStorePostConfigContentType = module.SduiApiStorePostConfigContentType
		local sduiCapabilities = module.SduiCapabilities
		local spotlightCollectionPageRequest = spotlight_collection_page.SpotlightCollectionPageRequest.new({
			spotlight_collection_id = p2,
			session_id = p3,
			client_capabilities = sduiCapabilities.buildClientCapabilities()
		})

		getSduiApiStore().fetchIfNeeded({
			responseType = sduiResponseType.ProtobufJson,
			url = module4(),
			surfaceKey = appPage.SduiLandingPage,
			configKey = v5,
			loadTimer = p4,
			apiProto = spotlight_collection_page.SpotlightCollectionPageResponse,
			postConfig = {
				contentType = sduiApiStorePostConfigContentType.Proto,
				protoMessage = spotlight_collection_page.SpotlightCollectionPageRequest,
				body = spotlightCollectionPageRequest
			}
		}, p5)

		return v5
	else
		local v5 = module3(p2, p3)
		local v6 = module2(p2)

		local spotlightCollectionPageResponse = require("@luauforge/deferred/hQx").apppageplatform.spotlightcollection.spotlight_collection_page.SpotlightCollectionPageResponse

		local v7 = {}

		local function getProtoForPageIdentifier(p6)
			return v7[p6] or spotlightCollectionPageResponse
		end
		getSduiApiStore().fetchIfNeeded({
			responseType = sduiResponseType.ProtobufJson,
			url = v5,
			surfaceKey = appPage.SduiLandingPage,
			configKey = v6,
			loadTimer = p4,
			apiProto = v7[p2] or spotlightCollectionPageResponse
		}, p5)

		return v6
	end
end

return fetchSduiLandingPage
