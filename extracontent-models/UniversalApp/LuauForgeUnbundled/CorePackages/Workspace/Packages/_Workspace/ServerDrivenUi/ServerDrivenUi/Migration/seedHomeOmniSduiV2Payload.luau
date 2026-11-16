local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedUtilities")
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local sduiLoadTimer = SduiSharedUtilities.SduiLoadTimer

local SduiV2OmniFeedConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Migration/SduiV2OmniFeedConstants")

local function seedHomeOmniSduiV2Payload(p2, p3, p4)
	local v5 = p4 or sduiLoadTimer.createLoadTimer(p3)

	local homePageResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServiceContractsProto").apppageplatform.home.home_page.HomePageResponse

	local jsonDecode = homePageResponse.jsonDecode(p2)

	getSduiApiStore().seedFromDecodedResponse({
		surfaceKey = p3,
		configKey = SduiV2OmniFeedConstants.HomeConfigKey,
		decodedResponse = jsonDecode,
		loadTimer = v5,
		apiProto = homePageResponse
	})
end

return seedHomeOmniSduiV2Payload
