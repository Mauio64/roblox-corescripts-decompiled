local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local SduiSharedUtilities = require(ServerDrivenUiParent.SduiSharedUtilities)
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local SduiV2OmniFeedConstants = require(ServerDrivenUi.Migration.SduiV2OmniFeedConstants)

local function seedHomeOmniSduiV2Payload(t1: {[any]: any}, s1: string, p1) -- line: 11
	-- upvalues: SduiLoadTimer (copy), ServerDrivenUiParent (copy), getSduiApiStore (copy), SduiV2OmniFeedConstants (copy)
	local v11 = p1 or SduiLoadTimer.createLoadTimer(s1)
	local HomePageResponse = require(ServerDrivenUiParent.ServiceContractsProto).apppageplatform.home.home_page.HomePageResponse
	local v13 = HomePageResponse.jsonDecode(t1)

	getSduiApiStore().seedFromDecodedResponse({
		surfaceKey = s1,
		configKey = SduiV2OmniFeedConstants.HomeConfigKey,
		decodedResponse = v13,
		loadTimer = v11,
		apiProto = HomePageResponse
	})
end

return seedHomeOmniSduiV2Payload
