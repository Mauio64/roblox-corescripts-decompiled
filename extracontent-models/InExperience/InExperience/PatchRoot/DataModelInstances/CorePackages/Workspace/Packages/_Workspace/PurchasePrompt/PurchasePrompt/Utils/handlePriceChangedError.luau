local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local MarketplaceService = game:GetService("MarketplaceService")
local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local clearProductInfoCaches = require(PurchasePrompt.Utils.clearProductInfoCaches)
local shouldCheckSubscriptionMembershipForProductType = require(PurchasePrompt.Utils.shouldCheckSubscriptionMembershipForProductType)
local FFlagEnablePriceChangedErrorHandling = require(PurchasePrompt.Flags.FFlagEnablePriceChangedErrorHandling)
local v8 = game:DefineFastFlag("ClearProductInfoCachesOnPriceChanged", false)
local v9 = game:DefineFastFlag("EnableConvertPriceChangedToUnknownFailure", false)
local EngineFeature = game:GetEngineFeature("EnableSignalCheckPlayerHasRobloxSubscription")

local function handlePriceChangedError(p1, p2, s1: string?) -- line: 20
	-- upvalues: FFlagEnablePriceChangedErrorHandling (copy), PurchaseError (copy), v8 (copy), clearProductInfoCaches (copy), EngineFeature (copy), shouldCheckSubscriptionMembershipForProductType (copy), MarketplaceService (copy), v9 (copy), ErrorOccurred (copy)
	if not FFlagEnablePriceChangedErrorHandling then
		return false
	end

	if p2 ~= PurchaseError.PriceChanged then
		return false
	end

	if v8 then
		clearProductInfoCaches()
	end

	if EngineFeature and shouldCheckSubscriptionMembershipForProductType(s1) then
		MarketplaceService:signalCheckPlayerHasRobloxSubscription()
	end

	local v15 = if not v9 then PurchaseError.PriceChanged else PurchaseError.UnknownFailure

	p1:dispatch(ErrorOccurred(v15))

	return true
end

return handlePriceChangedError
