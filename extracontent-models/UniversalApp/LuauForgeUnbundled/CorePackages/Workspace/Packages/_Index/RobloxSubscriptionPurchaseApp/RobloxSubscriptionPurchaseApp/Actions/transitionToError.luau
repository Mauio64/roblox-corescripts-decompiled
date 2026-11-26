local HttpService = game:GetService("HttpService")

local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")
local logSubscriptionPurchaseFlowEvent = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/logSubscriptionPurchaseFlowEvent")

local FFlagEnableSubscriptionPurchaseFlowEventIngest = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagEnableSubscriptionPurchaseFlowEventIngest")
local FFlagTTOnboardingSheet = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagTTOnboardingSheet")
local fFlagPlusMembershipConfigChangeCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagPlusMembershipConfigChangeCheck
local PromptState = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/PromptState")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/ErrorReason")
local RobloxPlusSheetKind = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/RobloxPlusSheetKind")
local logRobloxSubscriptionUpsellCounter = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/logRobloxSubscriptionUpsellCounter")
local RobloxSubscriptionUpsellTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Events/RobloxSubscriptionUpsellTelemetry")
local RobloxSubscriptionLogger = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/RobloxSubscriptionLogger")

function LUAUFORGE_MODULE_GLOBALS_aQE_transitionToError(p2, value)
	local v5 = RobloxSubscriptionStore.get()
	v5.setErrorReason(p2)
	v5.setPromptState(PromptState.Error)
	local v6 = if FFlagTTOnboardingSheet then v5.getPurchaseUIOptions() else nil

	RobloxSubscriptionLogger.debug({
		message = "Transitioning to error state",
		errorReason = tostring(p2),
		originalContext = value or "Unknown"
	})

	logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionPurchaseErrorShownCounter)

	if FFlagEnableSubscriptionPurchaseFlowEventIngest then
		local v11 = {
			error_reason = tostring(p2),
			original_context = value or "",
			sheet_kind = 0,
			include_upgrades = 0
		}

		local v12 = if FFlagTTOnboardingSheet and v6 and v6.sheetKind == RobloxPlusSheetKind.TT then RobloxPlusSheetKind.TT else nil
		v11.sheet_kind = v12

		v11.include_upgrades = fFlagPlusMembershipConfigChangeCheck
			and v5.getPurchaseFlowOptions().includeUpgrades == true
			and true
			or nil
		logSubscriptionPurchaseFlowEvent("SubscriptionPurchaseErrorShown", {
			event_metadata = HttpService:JSONEncode(v11)
		})
	end
end

return LUAUFORGE_MODULE_GLOBALS_aQE_transitionToError
