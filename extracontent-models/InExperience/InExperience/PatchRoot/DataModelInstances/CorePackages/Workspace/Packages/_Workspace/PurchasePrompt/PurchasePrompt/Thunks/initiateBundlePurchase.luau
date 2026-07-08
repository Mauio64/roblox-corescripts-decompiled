local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local RequestBundlePurchase = require(PurchasePrompt.Actions.RequestBundlePurchase)
local SetProductPayload = require(PurchasePrompt.Actions.SetProductPayload)
local buildProductPayloadFromInitiateArgs = require(PurchasePrompt.Utils.buildProductPayloadFromInitiateArgs)
local SetPurchaseFlowUUID = require(PurchasePrompt.Actions.SetPurchaseFlowUUID)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local getBundleDetails = require(PurchasePrompt.Network.getBundleDetails)
local getProductPurchasableDetails = require(PurchasePrompt.Network.getProductPurchasableDetails)
local getCatalogItemDetails = require(PurchasePrompt.Network.getCatalogItemDetails)
local getAccountInfo = require(PurchasePrompt.Network.getAccountInfo)
local getBalanceInfo = require(PurchasePrompt.Network.getBalanceInfo)
local getIsAlreadyOwned = require(PurchasePrompt.Network.getIsAlreadyOwned)
local Network = require(PurchasePrompt.Services.Network)
local ExternalSettings = require(PurchasePrompt.Services.ExternalSettings)
local hasPendingRequest = require(PurchasePrompt.Utils.hasPendingRequest)
local Promise = require(PurchasePrompt.Promise)
local Thunk = require(PurchasePrompt.Thunk)
local _ = require(PurchasePromptParent.AppCommonLib).Logging
local LoggingProtocol = require(PurchasePromptParent.LoggingProtocol)
local FFlagEnableUnifiedProductPurchaseFlow = require(PurchasePrompt.Parent.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local getUnifiedPurchaseFlowEligibility = require(PurchasePrompt.Network.getUnifiedPurchaseFlowEligibility)
local FFlagRemoveAcountInfoFetchFromPurchase = require(PurchasePrompt.Flags.FFlagRemoveAcountInfoFetchFromPurchase)
local resolveBundlePromptState = require(script.Parent.resolveBundlePromptState)
local fetchCartPricing = require(script.Parent.fetchCartPricing)
local FFlagPurchasePromptCartPricingEnabled = require(PurchasePrompt.Flags.FFlagPurchasePromptCartPricingEnabled)

local function maybeDispatchCartPricingFetch(p1) -- line: 37
	-- upvalues: FFlagPurchasePromptCartPricingEnabled (copy), fetchCartPricing (copy)
	if FFlagPurchasePromptCartPricingEnabled then
		p1:dispatch(fetchCartPricing())
	end
end

local GetFFlagUseCatalogItemDetailsToResolveBundlePurchase = require(PurchasePrompt.Flags.GetFFlagUseCatalogItemDetailsToResolveBundlePurchase)
local FFlagEnablePurchaseFlowUUIDMigration = require(PurchasePrompt.Flags.FFlagEnablePurchaseFlowUUIDMigration)
local FFlagUnifiedPurchaseOptimizeTTIMarketplace = require(PurchasePrompt.Parent.SharedFlags).FFlagUnifiedPurchaseOptimizeTTIMarketplace
local FFlagRefreshPriceOnRetryAfterUpsell = require(PurchasePrompt.Flags.FFlagRefreshPriceOnRetryAfterUpsell)
local v35 = if not FFlagRefreshPriceOnRetryAfterUpsell then nil else require(PurchasePrompt.Utils.applyRefreshedPrice)
local getRobloxSubscriptionProducts = require(PurchasePromptParent.RobloxSubscriptionPurchaseApp).Network.getRobloxSubscriptionProducts
local FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal = require(PurchasePrompt.Parent.SharedFlags).FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal
local PurchaseFlowUUIDTelemetry = require(PurchasePrompt.Events.PurchaseFlowUUIDTelemetry)
local t1 = {
	Network,
	ExternalSettings
}

local function initiateBundlePurchase(p2, p3, p4, p5, p6, p7, p8, b1: boolean?) -- line: 66
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), ExternalSettings (copy), hasPendingRequest (copy), FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal (copy), buildProductPayloadFromInitiateArgs (copy), SetProductPayload (copy), FFlagEnablePurchaseFlowUUIDMigration (copy), HttpService (copy), SetPurchaseFlowUUID (copy), LoggingProtocol (copy), PurchaseFlowUUIDTelemetry (copy), RequestBundlePurchase (copy), ErrorOccurred (copy), PurchaseError (copy), FFlagUnifiedPurchaseOptimizeTTIMarketplace (copy), FFlagRefreshPriceOnRetryAfterUpsell (copy), Promise (copy), getBundleDetails (copy), FFlagRemoveAcountInfoFetchFromPurchase (copy), Players (copy), getAccountInfo (copy), getBalanceInfo (copy), getIsAlreadyOwned (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), getUnifiedPurchaseFlowEligibility (copy), getRobloxSubscriptionProducts (copy), v35 (copy), resolveBundlePromptState (copy), FFlagPurchasePromptCartPricingEnabled (copy), fetchCartPricing (copy), GetFFlagUseCatalogItemDetailsToResolveBundlePurchase (copy), getCatalogItemDetails (copy), getProductPurchasableDetails (copy)
	return Thunk.new(script.Name, t1, function(p9, p10) -- line: 76
		-- upvalues: Network (copy), ExternalSettings (copy), hasPendingRequest (copy), FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal (copy), b1 (copy), buildProductPayloadFromInitiateArgs (copy), p2 (copy), p3 (copy), p4 (copy), p5 (copy), p6 (copy), p7 (copy), p8 (copy), SetProductPayload (copy), FFlagEnablePurchaseFlowUUIDMigration (copy), HttpService (copy), SetPurchaseFlowUUID (copy), LoggingProtocol (copy), PurchaseFlowUUIDTelemetry (copy), RequestBundlePurchase (copy), ErrorOccurred (copy), PurchaseError (copy), FFlagUnifiedPurchaseOptimizeTTIMarketplace (copy), FFlagRefreshPriceOnRetryAfterUpsell (copy), Promise (copy), getBundleDetails (copy), FFlagRemoveAcountInfoFetchFromPurchase (copy), Players (copy), getAccountInfo (copy), getBalanceInfo (copy), getIsAlreadyOwned (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), getUnifiedPurchaseFlowEligibility (copy), getRobloxSubscriptionProducts (copy), v35 (copy), resolveBundlePromptState (copy), FFlagPurchasePromptCartPricingEnabled (copy), fetchCartPricing (copy), GetFFlagUseCatalogItemDetailsToResolveBundlePurchase (copy), getCatalogItemDetails (copy), getProductPurchasableDetails (copy)
		local v52 = p10[Network]
		local v53 = p10[ExternalSettings]

		if hasPendingRequest(p9:getState()) and (not FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal or not b1) then
			return nil
		end

		if FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal then
			local productPayload = p9:getState().productPayload

			if not productPayload or not productPayload.kind then
				local v55 = buildProductPayloadFromInitiateArgs(p2, Enum.InfoType.Bundle, nil, nil, p3, p4, p5, p6, p7, p8, nil)

				if v55 then
					p9:dispatch(SetProductPayload(v55))
				end
			end
		end

		if FFlagEnablePurchaseFlowUUIDMigration then
			local guid = HttpService:GenerateGUID(false)

			p9:dispatch(SetPurchaseFlowUUID(guid))
			LoggingProtocol.default:logRobloxTelemetryCounter(PurchaseFlowUUIDTelemetry.InitiatePurchaseCounter, 1, {
				method = "initiateBundlePurchase"
			})
		end

		p9:dispatch(RequestBundlePurchase(p2, p3, p4, p5, p6, p7, p8))

		if v53.getFlagOrder66() then
			p9:dispatch(ErrorOccurred(PurchaseError.PurchaseDisabled))

			return nil
		end

		local v57 = nil
		local providedRobuxBalance = nil
		local fetchProductInfo = nil

		if FFlagUnifiedPurchaseOptimizeTTIMarketplace then
			local v60 = p9:getState()
			local purchaseOptions = v60.purchaseOptions
			local purchaseCallbacks = v60.purchaseCallbacks

			if purchaseOptions ~= nil and purchaseOptions.shouldSkipOwnershipCheck == true then
				v57 = true
			end

			if purchaseOptions ~= nil and purchaseOptions.providedRobuxBalance ~= nil then
				providedRobuxBalance = purchaseOptions.providedRobuxBalance
			end

			if purchaseCallbacks ~= nil and purchaseCallbacks.fetchProductInfo ~= nil then
				fetchProductInfo = purchaseCallbacks.fetchProductInfo
			end
		end

		local t2 = nil

		if FFlagRefreshPriceOnRetryAfterUpsell and b1 then
			local productPayload = p9:getState().productPayload

			t2 = {
				collectibleItemId = p5,
				collectibleItemInstanceId = p6,
				timedOptionDays = if not productPayload then nil else productPayload.timedOptionDays
			}
		end

		return Promise.all({
			bundleDetails = if not FFlagUnifiedPurchaseOptimizeTTIMarketplace or (fetchProductInfo == nil or not not FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal and b1) then getBundleDetails(v52, p2, if not FFlagRefreshPriceOnRetryAfterUpsell then nil else t2) else fetchProductInfo(),
			accountInfo = if not FFlagRemoveAcountInfoFetchFromPurchase then getAccountInfo(v52, v53) else Promise.resolve({
				isPremium = Players.LocalPlayer.MembershipType == Enum.MembershipType.Premium
			}),
			balanceInfo = getBalanceInfo(v52, v53, false, nil, if not FFlagUnifiedPurchaseOptimizeTTIMarketplace then nil else providedRobuxBalance),
			alreadyOwned = getIsAlreadyOwned(v52, p2, Enum.InfoType.Bundle, if not FFlagUnifiedPurchaseOptimizeTTIMarketplace then nil else v57),
			isUserEligibleForUnifiedPurchaseFlow = if not FFlagEnableUnifiedProductPurchaseFlow then nil else getUnifiedPurchaseFlowEligibility(v52),
			robloxSubscriptionProducts = if not FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal then nil else getRobloxSubscriptionProducts(v52):catch(function() -- line: 199
				return nil
			end)
		}):andThen(function(p11) -- line: 204
			-- upvalues: p8 (copy), FFlagRefreshPriceOnRetryAfterUpsell (copy), b1 (copy), v35 (copy), p9 (copy), FFlagUnifiedPurchaseOptimizeTTIMarketplace (copy), resolveBundlePromptState (copy), FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal (copy), FFlagPurchasePromptCartPricingEnabled (copy), fetchCartPricing (copy), GetFFlagUseCatalogItemDetailsToResolveBundlePurchase (copy), getCatalogItemDetails (copy), v52 (copy), p2 (copy), ErrorOccurred (copy), getProductPurchasableDetails (copy), PurchaseError (copy)
			local u66 = p8

			if FFlagRefreshPriceOnRetryAfterUpsell and b1 then
				local refreshedExpectedPrice = p11.bundleDetails.refreshedExpectedPrice

				if refreshedExpectedPrice ~= nil then
					u66 = refreshedExpectedPrice
					v35(p9, refreshedExpectedPrice)
				end
			end

			if p11.bundleDetails.product then
				if FFlagUnifiedPurchaseOptimizeTTIMarketplace then
					p9:dispatch(resolveBundlePromptState(nil, p11.bundleDetails, p11.accountInfo, p11.balanceInfo, u66, p11.alreadyOwned, p11.isUserEligibleForUnifiedPurchaseFlow, if not FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal then nil else p11.robloxSubscriptionProducts))

					local v68 = p9

					if FFlagPurchasePromptCartPricingEnabled then
						v68:dispatch(fetchCartPricing())
					end

					return
				end

				if GetFFlagUseCatalogItemDetailsToResolveBundlePurchase() then
					getCatalogItemDetails(v52, p2, "bundle"):andThen(function(p12) -- line: 236
						-- upvalues: p9 (copy), resolveBundlePromptState (copy), p11 (copy), u66 (ref), FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal (copy), FFlagPurchasePromptCartPricingEnabled (copy), fetchCartPricing (copy)
						p9:dispatch(resolveBundlePromptState(p12, p11.bundleDetails, p11.accountInfo, p11.balanceInfo, u66, p11.alreadyOwned, p11.isUserEligibleForUnifiedPurchaseFlow, if not FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal then nil else p11.robloxSubscriptionProducts))

						local v72 = p9

						if FFlagPurchasePromptCartPricingEnabled then
							v72:dispatch(fetchCartPricing())
						end
					end):catch(function(p13) -- line: 253
						-- upvalues: p9 (copy), ErrorOccurred (copy)
						p9:dispatch(ErrorOccurred(p13))
					end)
				else
					local id = p11.bundleDetails.product.id

					getProductPurchasableDetails(v52, id):andThen(function(p14) -- line: 259
						-- upvalues: p9 (copy), resolveBundlePromptState (copy), p11 (copy), u66 (ref), FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal (copy), FFlagPurchasePromptCartPricingEnabled (copy), fetchCartPricing (copy)
						p9:dispatch(resolveBundlePromptState(p14, p11.bundleDetails, p11.accountInfo, p11.balanceInfo, u66, p11.alreadyOwned, p11.isUserEligibleForUnifiedPurchaseFlow, if not FFlagEnableBlackbirdUpsellInUnifiedPurchaseModal then nil else p11.robloxSubscriptionProducts))

						local v75 = p9

						if FFlagPurchasePromptCartPricingEnabled then
							v75:dispatch(fetchCartPricing())
						end
					end)
				end
			else
				p9:dispatch(ErrorOccurred(PurchaseError.NotForSale))
			end
		end):catch(function(p15) -- line: 283
			-- upvalues: p9 (copy), ErrorOccurred (copy)
			p9:dispatch(ErrorOccurred(p15))
		end)
	end)
end

return initiateBundlePurchase
