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

function transitionToError(p1, s1: string) -- line: 19
	-- upvalues: RobloxSubscriptionStore (copy), PromptState (copy), RobloxSubscriptionLogger (copy), logRobloxSubscriptionUpsellCounter (copy), RobloxSubscriptionUpsellTelemetry (copy), FFlagEnableSubscriptionPurchaseFlowEventIngest (copy), logSubscriptionPurchaseFlowEvent (copy), HttpService (copy)
	local v12 = RobloxSubscriptionStore.get()

	v12.setErrorReason(p1)
	v12.setPromptState(PromptState.Error)
	RobloxSubscriptionLogger.debug({
		message = "Transitioning to error state",
		errorReason = tostring(p1),
		originalContext = s1 or "Unknown"
	})
	logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionPurchaseErrorShownCounter)

	if FFlagEnableSubscriptionPurchaseFlowEventIngest then
		logSubscriptionPurchaseFlowEvent("SubscriptionPurchaseErrorShown", {
			event_metadata = HttpService:JSONEncode({
				error_reason = tostring(p1),
				original_context = s1 or ""
			})
		})
	end
end

return transitionToError
