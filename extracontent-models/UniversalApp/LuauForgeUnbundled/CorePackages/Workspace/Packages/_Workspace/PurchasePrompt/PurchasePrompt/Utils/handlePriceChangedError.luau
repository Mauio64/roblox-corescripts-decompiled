local MarketplaceService = game:GetService("MarketplaceService")

local ErrorOccurred = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/ErrorOccurred")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local clearProductInfoCaches = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/clearProductInfoCaches")

local shouldCheckSubscriptionMembershipForProductType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/shouldCheckSubscriptionMembershipForProductType")

local FFlagEnablePriceChangedErrorHandling = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagEnablePriceChangedErrorHandling")
local defineFastFlag = game:DefineFastFlag("ClearProductInfoCachesOnPriceChanged", false)

local defineFastFlag2 = game:DefineFastFlag("EnableConvertPriceChangedToUnknownFailure", false)

local engineFeature = game:GetEngineFeature("EnableSignalCheckPlayerHasRobloxSubscription")

local function handlePriceChangedError(object, p2, p3): boolean
	if not (FFlagEnablePriceChangedErrorHandling and p2 == PurchaseError.PriceChanged) then
		return false
	end

	if defineFastFlag then
		clearProductInfoCaches()
	end

	if engineFeature and shouldCheckSubscriptionMembershipForProductType(p3) then
		MarketplaceService:signalCheckPlayerHasRobloxSubscription()
	end

	local v5 = if defineFastFlag2 then PurchaseError.UnknownFailure else PurchaseError.PriceChanged
	object:dispatch(ErrorOccurred(v5))
	return true
end

return handlePriceChangedError
