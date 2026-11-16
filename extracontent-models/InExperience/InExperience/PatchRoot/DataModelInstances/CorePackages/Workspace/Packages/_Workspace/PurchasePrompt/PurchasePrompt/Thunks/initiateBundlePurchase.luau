local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
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
local getBalanceInfo = require(PurchasePrompt.Network.getBalanceInfo)
local getIsAlreadyOwned = require(PurchasePrompt.Network.getIsAlreadyOwned)
local Network = require(PurchasePrompt.Services.Network)
local ExternalSettings = require(PurchasePrompt.Services.ExternalSettings)
local hasPendingRequest = require(PurchasePrompt.Utils.hasPendingRequest)
local Promise = require(PurchasePrompt.Promise)
local Thunk = require(PurchasePrompt.Thunk)
local IxpServiceWrapper = require(parent.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper
local v = require(parent.AppCommonLib)
v = v.Logging
local LoggingProtocol = require(parent.LoggingProtocol)

local SharedFlags = require(PurchasePrompt.Parent.SharedFlags)
local FFlagEnableFetchCartPricingDuringInExperience = SharedFlags.FFlagEnableFetchCartPricingDuringInExperience

local SharedFlags2 = require(PurchasePrompt.Parent.SharedFlags)
local FFlagAXFetchCartPricingDuringInExperienceExposure = SharedFlags2.FFlagAXFetchCartPricingDuringInExperienceExposure

local SharedFlags3 = require(PurchasePrompt.Parent.SharedFlags)
local FStringAXFetchCartPricingDuringInExperienceLayerName = SharedFlags3.FStringAXFetchCartPricingDuringInExperienceLayerName
local getUnifiedPurchaseFlowEligibility = require(PurchasePrompt.Network.getUnifiedPurchaseFlowEligibility)

local resolveBundlePromptState = require(script.Parent.resolveBundlePromptState)
local fetchCartPricing = require(script.Parent.fetchCartPricing)
local FFlagEnableInExperiencePurchaseModalMetrics = require(PurchasePrompt.Flags.FFlagEnableInExperiencePurchaseModalMetrics)
local trackInExperiencePurchaseStart = require(PurchasePrompt.Utils.trackInExperiencePurchaseStart)

local FFlagEnablePurchaseFlowUUIDMigration = require(PurchasePrompt.Flags.FFlagEnablePurchaseFlowUUIDMigration)

local SharedFlags4 = require(PurchasePrompt.Parent.SharedFlags)
local FFlagUnifiedPurchaseOptimizeTTIMarketplace = SharedFlags4.FFlagUnifiedPurchaseOptimizeTTIMarketplace

local FFlagRefreshPriceOnRetryAfterUpsell = require(PurchasePrompt.Flags.FFlagRefreshPriceOnRetryAfterUpsell)
local applyRefreshedPrice

if FFlagRefreshPriceOnRetryAfterUpsell then
	applyRefreshedPrice = require(PurchasePrompt.Utils.applyRefreshedPrice)
else
	applyRefreshedPrice = nil
end

local RobloxSubscriptionPurchaseApp = require(parent.RobloxSubscriptionPurchaseApp)
local getRobloxSubscriptionProducts = RobloxSubscriptionPurchaseApp.Network.getRobloxSubscriptionProducts

local PurchaseFlowUUIDTelemetry = require(PurchasePrompt.Events.PurchaseFlowUUIDTelemetry)

local v2 = { Network, ExternalSettings }

local function initiateBundlePurchase(p, p2, p3, collectibleItemId, collectibleItemInstanceId, p4, p5, flag: boolean?)
	return Thunk.new(script.Name, v2, function(object, p6)
		local v3 = p6[Network]
		local v4 = p6[ExternalSettings]

		if hasPendingRequest(object:getState()) and not flag then
			return nil
		end

		local productPayload = object:getState().productPayload
		local v5 = not (productPayload and productPayload.kind)
			and buildProductPayloadFromInitiateArgs(
				p,
				Enum.InfoType.Bundle,
				nil,
				nil,
				p2,
				p3,
				collectibleItemId,
				collectibleItemInstanceId,
				p4,
				p5,
				nil
			)

		if v5 then
			object:dispatch(SetProductPayload(v5))
		end

		if FFlagEnablePurchaseFlowUUIDMigration then
			object:dispatch(SetPurchaseFlowUUID((HttpService:GenerateGUID(false))))

			LoggingProtocol.default:logRobloxTelemetryCounter(PurchaseFlowUUIDTelemetry.InitiatePurchaseCounter, 1, {
				method = "initiateBundlePurchase"
			})
		end

		object:dispatch(RequestBundlePurchase(p, p2, p3, collectibleItemId, collectibleItemInstanceId, p4, p5))

		if v4.getFlagOrder66() then
			object:dispatch(ErrorOccurred(PurchaseError.PurchaseDisabled))
			return nil
		end

		if FFlagEnableInExperiencePurchaseModalMetrics and not flag then
			trackInExperiencePurchaseStart(object)
		end

		local v6 = nil
		local providedRobuxBalance = nil
		local fetchProductInfo = nil

		if FFlagUnifiedPurchaseOptimizeTTIMarketplace then
			local state = object:getState()
			local purchaseOptions = state.purchaseOptions
			local purchaseCallbacks = state.purchaseCallbacks

			v6 = purchaseOptions ~= nil and purchaseOptions.shouldSkipOwnershipCheck == true or v6

			if purchaseOptions ~= nil and purchaseOptions.providedRobuxBalance ~= nil then
				providedRobuxBalance = purchaseOptions.providedRobuxBalance
			end

			if purchaseCallbacks ~= nil and purchaseCallbacks.fetchProductInfo ~= nil then
				fetchProductInfo = purchaseCallbacks.fetchProductInfo
			end
		end

		local v7

		if FFlagRefreshPriceOnRetryAfterUpsell and flag then
			local productPayload2 = object:getState().productPayload
			v7 = {
				collectibleItemId = collectibleItemId,
				collectibleItemInstanceId = collectibleItemInstanceId,
				timedOptionDays = 0
			}
			local timedOptionDays

			if productPayload2 then
				timedOptionDays = productPayload2.timedOptionDays
			end

			v7.timedOptionDays = timedOptionDays
		end

		local cartPricingResponse

		if FFlagEnableFetchCartPricingDuringInExperience then
			if object:getState().purchaseOptions.shouldFetchCartPricing then
				cartPricingResponse = object:dispatch(fetchCartPricing())
			end
		else
			cartPricingResponse = object:dispatch(fetchCartPricing())
		end

		if
			FFlagAXFetchCartPricingDuringInExperienceExposure
			and not (object:getState().purchaseOptions.shouldFetchCartPricing or flag)
		then
			IXPServiceWrapper:LogFlagLinkedUserLayerExposure(FStringAXFetchCartPricingDuringInExperienceLayerName)
		end

		local fn = FFlagEnableFetchCartPricingDuringInExperience
			and not (object:getState().purchaseOptions.shouldFetchCartPricing or flag)
			and function(p7)
				return object:dispatch(fetchCartPricing(nil, p7))
			end
			or nil

		local all = Promise.all
		local bundleDetails

		if FFlagUnifiedPurchaseOptimizeTTIMarketplace and fetchProductInfo ~= nil and not flag then
			bundleDetails = fetchProductInfo()
		else
			if not FFlagRefreshPriceOnRetryAfterUpsell then
				v7 = nil
			end

			if not FFlagEnableFetchCartPricingDuringInExperience then
				fn = nil
			end

			bundleDetails = getBundleDetails(v3, p, v7, fn)
		end

		local v8 = {
			bundleDetails = bundleDetails,
			accountInfo = Promise.resolve({
				isPremium = Players.LocalPlayer.MembershipType == Enum.MembershipType.Premium
			}),
			balanceInfo = 0,
			alreadyOwned = 0,
			isUserEligibleForUnifiedPurchaseFlow = 0,
			robloxSubscriptionProducts = 0,
			cartPricingResponse = 0
		}

		if not FFlagUnifiedPurchaseOptimizeTTIMarketplace then
			providedRobuxBalance = nil
		end

		v8.balanceInfo = getBalanceInfo(v3, v4, false, nil, providedRobuxBalance)

		local bundle = Enum.InfoType.Bundle

		if not FFlagUnifiedPurchaseOptimizeTTIMarketplace then
			v6 = nil
		end

		v8.alreadyOwned = getIsAlreadyOwned(v3, p, bundle, v6)

		v8.isUserEligibleForUnifiedPurchaseFlow = getUnifiedPurchaseFlowEligibility(v3)
		v8.robloxSubscriptionProducts = getRobloxSubscriptionProducts(v3):catch(function(): nil
			return nil
		end)

		v8.cartPricingResponse = cartPricingResponse
		return all(v8):andThen(function(data)
			local v9 = p5

			if FFlagRefreshPriceOnRetryAfterUpsell and flag then
				local refreshedExpectedPrice = data.bundleDetails.refreshedExpectedPrice

				if refreshedExpectedPrice ~= nil then
					applyRefreshedPrice(object, refreshedExpectedPrice)
					v9 = refreshedExpectedPrice
				end
			end

			if data.bundleDetails.product then
				if FFlagUnifiedPurchaseOptimizeTTIMarketplace then
					object:dispatch(resolveBundlePromptState(
						nil,
						data.bundleDetails,
						data.accountInfo,
						data.balanceInfo,
						v9,
						data.alreadyOwned,
						data.isUserEligibleForUnifiedPurchaseFlow,
						data.robloxSubscriptionProducts
					))
				else
					getProductPurchasableDetails(v3, data.bundleDetails.product.id):andThen(function(p7)
						object:dispatch(resolveBundlePromptState(
							p7,
							data.bundleDetails,
							data.accountInfo,
							data.balanceInfo,
							v9,
							data.alreadyOwned,
							data.isUserEligibleForUnifiedPurchaseFlow,
							data.robloxSubscriptionProducts
						))
					end)
				end
			else
				object:dispatch(ErrorOccurred(PurchaseError.NotForSale))
			end
		end):catch(function(p7)
			object:dispatch(ErrorOccurred(p7))
		end)
	end)
end

return initiateBundlePurchase
