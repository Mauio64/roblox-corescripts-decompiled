local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

local HttpService = game:GetService("HttpService")

local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)
local logSubscriptionPurchaseFlowEvent = require(RobloxSubscriptionPurchaseApp.Utils.logSubscriptionPurchaseFlowEvent)

local FFlagEnableSubscriptionPurchaseFlowEventIngest = require(RobloxSubscriptionPurchaseApp.Flags.FFlagEnableSubscriptionPurchaseFlowEventIngest)
local FFlagTTOnboardingSheet = require(RobloxSubscriptionPurchaseApp.Flags.FFlagTTOnboardingSheet)
local SharedFlags = require(parent.SharedFlags)
local FFlagPlusMembershipConfigChangeCheck = SharedFlags.FFlagPlusMembershipConfigChangeCheck
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)
require(RobloxSubscriptionPurchaseApp.Enums.ErrorReason)
local RobloxPlusSheetKind = require(RobloxSubscriptionPurchaseApp.Enums.RobloxPlusSheetKind)
local logRobloxSubscriptionUpsellCounter = require(RobloxSubscriptionPurchaseApp.Utils.logRobloxSubscriptionUpsellCounter)
local RobloxSubscriptionUpsellTelemetry = require(RobloxSubscriptionPurchaseApp.Events.RobloxSubscriptionUpsellTelemetry)
local RobloxSubscriptionLogger = require(RobloxSubscriptionPurchaseApp.Utils.RobloxSubscriptionLogger)

function transitionToError(p, value: string)
	local v = RobloxSubscriptionStore.get()
	v.setErrorReason(p)
	v.setPromptState(PromptState.Error)
	local v2

	if FFlagTTOnboardingSheet then
		v2 = v.getPurchaseUIOptions()
	end

	RobloxSubscriptionLogger.debug({
		message = "Transitioning to error state",
		errorReason = tostring(p),
		originalContext = value or "Unknown"
	})

	logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionPurchaseErrorShownCounter)

	if FFlagEnableSubscriptionPurchaseFlowEventIngest then
		local v3 = {
			error_reason = tostring(p),
			original_context = value or "",
			sheet_kind = 0,
			include_upgrades = 0
		}
		local sheet_kind

		if FFlagTTOnboardingSheet and v2 and v2.sheetKind == RobloxPlusSheetKind.TT then
			sheet_kind = RobloxPlusSheetKind.TT
		end

		v3.sheet_kind = sheet_kind

		v3.include_upgrades = FFlagPlusMembershipConfigChangeCheck
			and v.getPurchaseFlowOptions().includeUpgrades == true
			and true
			or nil
		logSubscriptionPurchaseFlowEvent("SubscriptionPurchaseErrorShown", {
			event_metadata = HttpService:JSONEncode(v3)
		})
	end
end

return transitionToError
