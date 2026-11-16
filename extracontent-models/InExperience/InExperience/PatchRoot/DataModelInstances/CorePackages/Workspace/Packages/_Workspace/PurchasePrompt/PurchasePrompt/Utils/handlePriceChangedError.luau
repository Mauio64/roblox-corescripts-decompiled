local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local MarketplaceService = game:GetService("MarketplaceService")

local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local clearProductInfoCaches = require(PurchasePrompt.Utils.clearProductInfoCaches)

local shouldCheckSubscriptionMembershipForProductType = require(PurchasePrompt.Utils.shouldCheckSubscriptionMembershipForProductType)

local FFlagEnablePriceChangedErrorHandling = require(PurchasePrompt.Flags.FFlagEnablePriceChangedErrorHandling)
local defineFastFlag = game:DefineFastFlag("ClearProductInfoCachesOnPriceChanged", false)

local defineFastFlag2 = game:DefineFastFlag("EnableConvertPriceChangedToUnknownFailure", false)

local engineFeature = game:GetEngineFeature("EnableSignalCheckPlayerHasRobloxSubscription")

local function handlePriceChangedError(object, p, p2: string?): boolean
	if not (FFlagEnablePriceChangedErrorHandling and p == PurchaseError.PriceChanged) then
		return false
	end

	if defineFastFlag then
		clearProductInfoCaches()
	end

	if engineFeature and shouldCheckSubscriptionMembershipForProductType(p2) then
		MarketplaceService:signalCheckPlayerHasRobloxSubscription()
	end

	local v

	if defineFastFlag2 then
		v = PurchaseError.UnknownFailure
	else
		v = PurchaseError.PriceChanged
	end

	object:dispatch(ErrorOccurred(v))
	return true
end

return handlePriceChangedError
