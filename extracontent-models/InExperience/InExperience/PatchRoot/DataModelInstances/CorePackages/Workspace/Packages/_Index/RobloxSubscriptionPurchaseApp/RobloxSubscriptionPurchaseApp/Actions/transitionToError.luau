local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")

local HttpService = game:GetService("HttpService")

local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local logSubscriptionPurchaseFlowEvent = require(RobloxSubscriptionPurchaseApp.Utils.logSubscriptionPurchaseFlowEvent)

local FFlagEnableSubscriptionPurchaseFlowEventIngest = require(RobloxSubscriptionPurchaseApp.Flags.FFlagEnableSubscriptionPurchaseFlowEventIngest)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)
require(RobloxSubscriptionPurchaseApp.Enums.ErrorReason)
local logRobloxSubscriptionUpsellCounter = require(RobloxSubscriptionPurchaseApp.Utils.logRobloxSubscriptionUpsellCounter)
local RobloxSubscriptionUpsellTelemetry = require(RobloxSubscriptionPurchaseApp.Events.RobloxSubscriptionUpsellTelemetry)
local RobloxSubscriptionLogger = require(RobloxSubscriptionPurchaseApp.Utils.RobloxSubscriptionLogger)

function transitionToError(p, value: string)
	local v = RobloxSubscriptionStore.get()
	v.setErrorReason(p)
	v.setPromptState(PromptState.Error)

	RobloxSubscriptionLogger.debug({
		message = "Transitioning to error state",
		errorReason = tostring(p),
		originalContext = value or "Unknown"
	})

	logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionPurchaseErrorShownCounter)

	if FFlagEnableSubscriptionPurchaseFlowEventIngest then
		logSubscriptionPurchaseFlowEvent("SubscriptionPurchaseErrorShown", {
			event_metadata = HttpService:JSONEncode({
				error_reason = tostring(p),
				original_context = value or ""
			})
		})
	end
end

return transitionToError
