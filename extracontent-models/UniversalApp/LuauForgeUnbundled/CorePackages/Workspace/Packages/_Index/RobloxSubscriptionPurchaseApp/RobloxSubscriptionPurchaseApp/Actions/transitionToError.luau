local HttpService = game:GetService("HttpService")

local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")
local logSubscriptionPurchaseFlowEvent = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/logSubscriptionPurchaseFlowEvent")

local FFlagEnableSubscriptionPurchaseFlowEventIngest = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagEnableSubscriptionPurchaseFlowEventIngest")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/PromptState")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/ErrorReason")
local logRobloxSubscriptionUpsellCounter = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/logRobloxSubscriptionUpsellCounter")
local RobloxSubscriptionUpsellTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Events/RobloxSubscriptionUpsellTelemetry")
local RobloxSubscriptionLogger = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/RobloxSubscriptionLogger")

function LUAUFORGE_MODULE_GLOBALS_aPg_transitionToError(p2, value)
	local v5 = RobloxSubscriptionStore.get()
	v5.setErrorReason(p2)
	v5.setPromptState(PromptState.Error)

	RobloxSubscriptionLogger.debug({
		message = "Transitioning to error state",
		errorReason = tostring(p2),
		originalContext = value or "Unknown"
	})

	logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionPurchaseErrorShownCounter)

	if FFlagEnableSubscriptionPurchaseFlowEventIngest then
		logSubscriptionPurchaseFlowEvent("SubscriptionPurchaseErrorShown", {
			event_metadata = HttpService:JSONEncode({
				error_reason = tostring(p2),
				original_context = value or ""
			})
		})
	end
end

return LUAUFORGE_MODULE_GLOBALS_aPg_transitionToError
