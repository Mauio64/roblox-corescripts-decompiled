local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")

local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local RobloxSubscriptionStore = require(RobloxSubscriptionPurchaseApp.Store.RobloxSubscriptionStore)

local getSubscriptionPurchaseUrl = require(RobloxSubscriptionPurchaseApp.Utils.getSubscriptionPurchaseUrl)
local WebViewServiceWrapper = require(RobloxSubscriptionPurchaseApp.Utils.WebViewServiceWrapper)
local PromptState = require(RobloxSubscriptionPurchaseApp.Enums.PromptState)
local Constants = require(RobloxSubscriptionPurchaseApp.Constants)
require(RobloxSubscriptionPurchaseApp.Models.GetRobloxSubscriptionProductsModel)
local completeRobloxSubscriptionUpsellFlow = require(RobloxSubscriptionPurchaseApp.Actions.completeRobloxSubscriptionUpsellFlow)
local transitionToError = require(RobloxSubscriptionPurchaseApp.Actions.transitionToError)
local ErrorReason = require(RobloxSubscriptionPurchaseApp.Enums.ErrorReason)

local RobloxSubscriptionUpsellTelemetry = require(RobloxSubscriptionPurchaseApp.Events.RobloxSubscriptionUpsellTelemetry)
local logRobloxSubscriptionUpsellCounter = require(RobloxSubscriptionPurchaseApp.Utils.logRobloxSubscriptionUpsellCounter)
local logSubscriptionPurchaseFlowEvent = require(RobloxSubscriptionPurchaseApp.Utils.logSubscriptionPurchaseFlowEvent)

local FFlagEnableSubscriptionPurchaseFlowEventIngest = require(RobloxSubscriptionPurchaseApp.Flags.FFlagEnableSubscriptionPurchaseFlowEventIngest)

local FFlagEnableStudioMockPurchaseRobloxSubscription = require(RobloxSubscriptionPurchaseApp.Flags.FFlagEnableStudioMockPurchaseRobloxSubscription)
local parent = RobloxSubscriptionPurchaseApp.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagEnablePlusReferralLandingSheet = SharedFlags.FFlagEnablePlusReferralLandingSheet
local defineFastString = game:DefineFastString("FStringBlackbirdWebviewHeaderName", "Black bird")
local engineFeature = game:GetEngineFeature("EnableSubscriptionPurchaseReferrerId")

local function getPaymentProviderForPlatform(platform): string -- 1 equivalent call inferred from this helper
	if platform == Enum.Platform.IOS then
		return "AppleAppStore"
	end

	if platform == Enum.Platform.Android then
		return "GooglePlayStore"
	end

	return "Unknown"
end

function performRobloxSubscriptionPurchase()
	local v = RobloxSubscriptionStore.get()
	local robloxSubscriptionProductId = v.getRobloxSubscriptionProductId()
	local paymentSessionId = v.getPaymentSessionId()

	if robloxSubscriptionProductId == nil then
		return
	end

	if FFlagEnableStudioMockPurchaseRobloxSubscription and RunService:IsStudio() then
		MarketplaceService:SignalMockPurchaseRobloxSubscription()
		v.setDidTryPurchasing(true)
		completeRobloxSubscriptionUpsellFlow()
	else
		if FFlagEnableSubscriptionPurchaseFlowEventIngest then
			logSubscriptionPurchaseFlowEvent("SubscriptionPurchaseAttempted")
		end

		local platform = UserInputService:GetPlatform()
		local v2 = platform == Enum.Platform.Windows or platform == Enum.Platform.OSX or platform == Enum.Platform.Linux
		local v3

		if FFlagEnablePlusReferralLandingSheet then
			v3 = v.getReferrerId()
		else
			v3 = nil
		end

		if v2 then
			v.setIsNativePurchase(false)
			v.setPromptState(PromptState.SubscriptionPurchaseUIReady)
			WebViewServiceWrapper.new({
				url = getSubscriptionPurchaseUrl(robloxSubscriptionProductId, paymentSessionId, v3),
				title = defineFastString,
				closeCallback = function()
					v.setDidTryPurchasing(true)
					completeRobloxSubscriptionUpsellFlow()
				end,
				onOpenCallback = function()
					v.setPromptState(PromptState.SubscriptionPurchaseInProgress)
				end
			}):open()
		else
			v.setPromptState(PromptState.SubscriptionPurchaseInProgress)
			local paymentProviderForPlatform = getPaymentProviderForPlatform(platform) -- inferred equivalent call
			v.setIsNativePurchase(true)

			local success, _ = pcall(function()
				if FFlagEnablePlusReferralLandingSheet and engineFeature and v3 then
					MarketplaceService:PerformSubscriptionPurchaseV3Async(
						Constants.ROBLOX_SUBSCRIPTION_PRODUCT_TYPE,
						robloxSubscriptionProductId,
						paymentProviderForPlatform,
						paymentSessionId,
						v3
					)
				else
					MarketplaceService:PerformSubscriptionPurchaseV3Async(
						Constants.ROBLOX_SUBSCRIPTION_PRODUCT_TYPE,
						robloxSubscriptionProductId,
						paymentProviderForPlatform,
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

return performRobloxSubscriptionPurchase
