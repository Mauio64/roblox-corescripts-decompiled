local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local RobloxSubscriptionStore = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Store/RobloxSubscriptionStore")

local getSubscriptionPurchaseUrl = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/getSubscriptionPurchaseUrl")
local WebViewServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/WebViewServiceWrapper")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/PromptState")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Models/GetRobloxSubscriptionProductsModel")
local completeRobloxSubscriptionUpsellFlow = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Actions/completeRobloxSubscriptionUpsellFlow")
local transitionToError = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Actions/transitionToError")
local ErrorReason = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/ErrorReason")
local claimEventSubscription = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Network/claimEventSubscription")
local RobloxPlusSheetKind = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Enums/RobloxPlusSheetKind")

local RobloxSubscriptionUpsellTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Events/RobloxSubscriptionUpsellTelemetry")
local logRobloxSubscriptionUpsellCounter = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/logRobloxSubscriptionUpsellCounter")
local logSubscriptionPurchaseFlowEvent = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/logSubscriptionPurchaseFlowEvent")
local FFlagTTOnboardingSheet = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagTTOnboardingSheet")

local FFlagEnableSubscriptionPurchaseFlowEventIngest = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagEnableSubscriptionPurchaseFlowEventIngest")

local FFlagEnableStudioMockPurchaseRobloxSubscription = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagEnableStudioMockPurchaseRobloxSubscription")

local fFlagEnablePlusReferralLandingSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/SharedFlags").FFlagEnablePlusReferralLandingSheet
local defineFastString = game:DefineFastString("FStringBlackbirdWebviewHeaderName", "Black bird")
local engineFeature = game:GetEngineFeature("EnableSubscriptionPurchaseReferrerId")

local function getPaymentProviderForPlatform(p2): string
	if p2 == Enum.Platform.IOS then
		return "AppleAppStore"
	end

	if p2 == Enum.Platform.Android then
		return "GooglePlayStore"
	end

	return "Unknown"
end

function LUAUFORGE_MODULE_GLOBALS_aTf_performRobloxSubscriptionPurchase()
	local v5 = RobloxSubscriptionStore.get()
	local robloxSubscriptionProductId = v5.getRobloxSubscriptionProductId()
	local paymentSessionId = v5.getPaymentSessionId()

	if robloxSubscriptionProductId == nil then
		return
	end

	if FFlagEnableStudioMockPurchaseRobloxSubscription and RunService:IsStudio() then
		MarketplaceService:SignalMockPurchaseRobloxSubscription()
		v5.setDidTryPurchasing(true)
		completeRobloxSubscriptionUpsellFlow()
	else
		if FFlagEnableSubscriptionPurchaseFlowEventIngest then
			logSubscriptionPurchaseFlowEvent("SubscriptionPurchaseAttempted")
		end

		if FFlagTTOnboardingSheet and v5.getPurchaseUIOptions().sheetKind == RobloxPlusSheetKind.TT then
			v5.setIsNativePurchase(false)
			v5.setPromptState(PromptState.SubscriptionPurchaseInProgress)

			claimEventSubscription():andThen(function()
				v5.setDidTryPurchasing(true)
				completeRobloxSubscriptionUpsellFlow()
			end, function()
				transitionToError(ErrorReason.GenericError, "performRobloxSubscriptionPurchase")
				logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellPurchaseFailedCounter)
			end)
		else
			local platform = UserInputService:GetPlatform()
			local v6 = platform == Enum.Platform.Windows
				or platform == Enum.Platform.OSX
				or platform == Enum.Platform.Linux

			local v7 = if fFlagEnablePlusReferralLandingSheet then v5.getReferrerId() else nil

			if v6 then
				v5.setIsNativePurchase(false)
				v5.setPromptState(PromptState.SubscriptionPurchaseUIReady)
				WebViewServiceWrapper.new({
					url = getSubscriptionPurchaseUrl(robloxSubscriptionProductId, paymentSessionId, v7),
					title = defineFastString,
					closeCallback = function()
						v5.setDidTryPurchasing(true)
						completeRobloxSubscriptionUpsellFlow()
					end,
					onOpenCallback = function()
						v5.setPromptState(PromptState.SubscriptionPurchaseInProgress)
					end
				}):open()
			else
				v5.setPromptState(PromptState.SubscriptionPurchaseInProgress)
				local v8 = platform == Enum.Platform.IOS and "AppleAppStore"
					or platform == Enum.Platform.Android and "GooglePlayStore"
					or "Unknown"

				v5.setIsNativePurchase(true)

				local success, result = pcall(function()
					if fFlagEnablePlusReferralLandingSheet and engineFeature and v7 then
						MarketplaceService:PerformSubscriptionPurchaseV3Async(
							Constants.ROBLOX_SUBSCRIPTION_PRODUCT_TYPE,
							robloxSubscriptionProductId,
							v8,
							paymentSessionId,
							v7
						)
					else
						MarketplaceService:PerformSubscriptionPurchaseV3Async(
							Constants.ROBLOX_SUBSCRIPTION_PRODUCT_TYPE,
							robloxSubscriptionProductId,
							v8,
							paymentSessionId
						)
					end
				end)

				if not success then
					transitionToError(ErrorReason.GenericError, "performRobloxSubscriptionPurchase")
					logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellPurchaseFailedCounter)
				end
			end
		end
	end
end

return LUAUFORGE_MODULE_GLOBALS_aTf_performRobloxSubscriptionPurchase
