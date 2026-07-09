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
local v18 = game:DefineFastString("FStringBlackbirdWebviewHeaderName", "Black bird")

local function getPaymentProviderForPlatform(p1) -- line: 34
	if p1 == Enum.Platform.IOS then
		return "AppleAppStore"
	end

	if p1 == Enum.Platform.Android then
		return "GooglePlayStore"
	end

	return "Unknown"
end

function performRobloxSubscriptionPurchase() -- line: 44
	-- upvalues: RobloxSubscriptionStore (copy), FFlagEnableStudioMockPurchaseRobloxSubscription (copy), RunService (copy), MarketplaceService (copy), completeRobloxSubscriptionUpsellFlow (copy), FFlagEnableSubscriptionPurchaseFlowEventIngest (copy), logSubscriptionPurchaseFlowEvent (copy), UserInputService (copy), PromptState (copy), WebViewServiceWrapper (copy), getSubscriptionPurchaseUrl (copy), v18 (copy), Constants (copy), transitionToError (copy), ErrorReason (copy), logRobloxSubscriptionUpsellCounter (copy), RobloxSubscriptionUpsellTelemetry (copy)
	local v21 = RobloxSubscriptionStore.get()
	local v22 = v21.getRobloxSubscriptionProductId()
	local v23 = v21.getPaymentSessionId()

	if v22 == nil then
		return
	end

	if FFlagEnableStudioMockPurchaseRobloxSubscription and RunService:IsStudio() then
		MarketplaceService:SignalMockPurchaseRobloxSubscription()
		v21.setDidTryPurchasing(true)
		completeRobloxSubscriptionUpsellFlow()

		return
	end

	if FFlagEnableSubscriptionPurchaseFlowEventIngest then
		logSubscriptionPurchaseFlowEvent("SubscriptionPurchaseAttempted")
	end

	local Platform = UserInputService:GetPlatform()

	if Platform == Enum.Platform.Windows or (Platform == Enum.Platform.OSX or Platform == Enum.Platform.Linux) then
		v21.setIsNativePurchase(false)
		v21.setPromptState(PromptState.SubscriptionPurchaseUIReady)
		WebViewServiceWrapper.new({
			url = getSubscriptionPurchaseUrl(v22, v23),
			title = v18,
			closeCallback = function() -- line: 77
				-- upvalues: v21 (copy), completeRobloxSubscriptionUpsellFlow (copy)
				v21.setDidTryPurchasing(true)
				completeRobloxSubscriptionUpsellFlow()
			end,
			onOpenCallback = function() -- line: 83
				-- upvalues: v21 (copy), PromptState (copy)
				v21.setPromptState(PromptState.SubscriptionPurchaseInProgress)
			end
		}):open()

		return
	end

	v21.setPromptState(PromptState.SubscriptionPurchaseInProgress)

	local v25 = if Platform ~= Enum.Platform.IOS then Platform ~= Enum.Platform.Android and "Unknown" or "GooglePlayStore" else "AppleAppStore"

	v21.setIsNativePurchase(true)

	local ok, _ = pcall(function() -- line: 96
		-- upvalues: MarketplaceService (copy), Constants (copy), v22 (copy), v25 (copy), v23 (copy)
		MarketplaceService:PerformSubscriptionPurchaseV3Async(Constants.ROBLOX_SUBSCRIPTION_PRODUCT_TYPE, v22, v25, v23)
	end)

	if not ok then
		transitionToError(ErrorReason.GenericError, "performRobloxSubscriptionPurchase")
		logRobloxSubscriptionUpsellCounter(RobloxSubscriptionUpsellTelemetry.RobloxSubscriptionUpsellPurchaseFailedCounter)
	end
end

return performRobloxSubscriptionPurchase
