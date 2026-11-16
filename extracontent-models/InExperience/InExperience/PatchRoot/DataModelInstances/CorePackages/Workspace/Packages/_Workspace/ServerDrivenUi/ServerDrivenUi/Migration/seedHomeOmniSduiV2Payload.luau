local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer

local SduiV2OmniFeedConstants = require(ServerDrivenUi.Migration.SduiV2OmniFeedConstants)

local function seedHomeOmniSduiV2Payload(p, surfaceKey: string, p2)
	local loadTimer = p2 or SduiLoadTimer.createLoadTimer(surfaceKey)

	local ServiceContractsProto = require(parent.ServiceContractsProto)
	local homePageResponse = ServiceContractsProto.apppageplatform.home.home_page.HomePageResponse

	local jsonDecode = homePageResponse.jsonDecode(p)

	getSduiApiStore().seedFromDecodedResponse({
		surfaceKey = surfaceKey,
		configKey = SduiV2OmniFeedConstants.HomeConfigKey,
		decodedResponse = jsonDecode,
		loadTimer = loadTimer,
		apiProto = homePageResponse
	})
end

return seedHomeOmniSduiV2Payload
