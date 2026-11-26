local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local ErrorOccurred = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/ErrorOccurred")
local RequestBundlePurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RequestBundlePurchase")
local SetProductPayload = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetProductPayload")
local buildProductPayloadFromInitiateArgs = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/buildProductPayloadFromInitiateArgs")
local SetPurchaseFlowUUID = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPurchaseFlowUUID")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local getBundleDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getBundleDetails")
local getProductPurchasableDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getProductPurchasableDetails")
local getBalanceInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getBalanceInfo")
local getIsAlreadyOwned = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getIsAlreadyOwned")
local Network = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Network")
local ExternalSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/ExternalSettings")
local hasPendingRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/hasPendingRequest")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")
local ixpServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IxpServiceWrapper").IXPServiceWrapper
local logging = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/AppCommonLib").Logging
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/LoggingProtocol")

local fFlagEnableFetchCartPricingDuringInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableFetchCartPricingDuringInExperience

local fFlagAXFetchCartPricingDuringInExperienceExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagAXFetchCartPricingDuringInExperienceExposure

local fStringAXFetchCartPricingDuringInExperienceLayerName = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FStringAXFetchCartPricingDuringInExperienceLayerName
local getUnifiedPurchaseFlowEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getUnifiedPurchaseFlowEligibility")

local resolveBundlePromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/resolveBundlePromptState")
local fetchCartPricing = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/fetchCartPricing")
local FFlagEnableInExperiencePurchaseModalMetrics = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagEnableInExperiencePurchaseModalMetrics")
local trackInExperiencePurchaseStart = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/trackInExperiencePurchaseStart")

local FFlagEnablePurchaseFlowUUIDMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagEnablePurchaseFlowUUIDMigration")

local fFlagUnifiedPurchaseOptimizeTTIMarketplace = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagUnifiedPurchaseOptimizeTTIMarketplace

local FFlagRefreshPriceOnRetryAfterUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagRefreshPriceOnRetryAfterUpsell")
local v5 = if FFlagRefreshPriceOnRetryAfterUpsell then require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/applyRefreshedPrice") else nil

local getRobloxSubscriptionProducts = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/RobloxSubscriptionPurchaseApp").Network.getRobloxSubscriptionProducts

local PurchaseFlowUUIDTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Events/PurchaseFlowUUIDTelemetry")

local v6 = { Network, ExternalSettings }

local function initiateBundlePurchase(p2, p3, p4, p5, p6, p7, p8, p9)
	return Thunk.new("initiateBundlePurchase", v6, function(object, p10)
		local v7 = p10[Network]
		local v8 = p10[ExternalSettings]

		if hasPendingRequest(object:getState()) and not p9 then
			return nil
		end

		local productPayload = object:getState().productPayload
		local v9 = not (productPayload and productPayload.kind)
			and buildProductPayloadFromInitiateArgs(p2, Enum.InfoType.Bundle, nil, nil, p3, p4, p5, p6, p7, p8, nil)

		if v9 then
			object:dispatch(SetProductPayload(v9))
		end

		if FFlagEnablePurchaseFlowUUIDMigration then
			object:dispatch(SetPurchaseFlowUUID((HttpService:GenerateGUID(false))))

			LoggingProtocol.default:logRobloxTelemetryCounter(PurchaseFlowUUIDTelemetry.InitiatePurchaseCounter, 1, {
				method = "initiateBundlePurchase"
			})
		end

		object:dispatch(RequestBundlePurchase(p2, p3, p4, p5, p6, p7, p8))

		if v8.getFlagOrder66() then
			object:dispatch(ErrorOccurred(PurchaseError.PurchaseDisabled))
			return nil
		end

		if FFlagEnableInExperiencePurchaseModalMetrics and not p9 then
			trackInExperiencePurchaseStart(object)
		end

		local v10 = nil
		local providedRobuxBalance = nil
		local fetchProductInfo = nil

		if fFlagUnifiedPurchaseOptimizeTTIMarketplace then
			local state = object:getState()
			local purchaseOptions = state.purchaseOptions
			local purchaseCallbacks = state.purchaseCallbacks

			v10 = purchaseOptions ~= nil and purchaseOptions.shouldSkipOwnershipCheck == true or v10

			if purchaseOptions ~= nil and purchaseOptions.providedRobuxBalance ~= nil then
				providedRobuxBalance = purchaseOptions.providedRobuxBalance
			end

			if purchaseCallbacks ~= nil and purchaseCallbacks.fetchProductInfo ~= nil then
				fetchProductInfo = purchaseCallbacks.fetchProductInfo
			end
		end

		local v11

		if FFlagRefreshPriceOnRetryAfterUpsell and p9 then
			local productPayload2 = object:getState().productPayload
			v11 = {
				collectibleItemId = p5,
				collectibleItemInstanceId = p6,
				timedOptionDays = 0
			}

			local v12 = if productPayload2 then productPayload2.timedOptionDays else nil
			v11.timedOptionDays = v12
		end

		local v12

		if fFlagEnableFetchCartPricingDuringInExperience then
			if object:getState().purchaseOptions.shouldFetchCartPricing then
				v12 = object:dispatch(fetchCartPricing())
			end
		else
			v12 = object:dispatch(fetchCartPricing())
		end

		if
			fFlagAXFetchCartPricingDuringInExperienceExposure
			and not (object:getState().purchaseOptions.shouldFetchCartPricing or p9)
		then
			ixpServiceWrapper:LogFlagLinkedUserLayerExposure(fStringAXFetchCartPricingDuringInExperienceLayerName)
		end

		local fn = fFlagEnableFetchCartPricingDuringInExperience
			and not (object:getState().purchaseOptions.shouldFetchCartPricing or p9)
			and function(p11)
				return object:dispatch(fetchCartPricing(nil, p11))
			end
			or nil

		local all = Promise.all
		local v14

		if fFlagUnifiedPurchaseOptimizeTTIMarketplace and fetchProductInfo ~= nil and not p9 then
			v14 = fetchProductInfo()
		else
			if not FFlagRefreshPriceOnRetryAfterUpsell then
				v11 = nil
			end

			if not fFlagEnableFetchCartPricingDuringInExperience then
				fn = nil
			end

			v14 = getBundleDetails(v7, p2, v11, fn)
		end

		local v13 = {
			bundleDetails = v14,
			accountInfo = Promise.resolve({
				isPremium = Players.LocalPlayer.MembershipType == Enum.MembershipType.Premium
			}),
			balanceInfo = 0,
			alreadyOwned = 0,
			isUserEligibleForUnifiedPurchaseFlow = 0,
			robloxSubscriptionProducts = 0,
			cartPricingResponse = 0
		}

		if not fFlagUnifiedPurchaseOptimizeTTIMarketplace then
			providedRobuxBalance = nil
		end

		v13.balanceInfo = getBalanceInfo(v7, v8, false, nil, providedRobuxBalance)

		local bundle = Enum.InfoType.Bundle

		if not fFlagUnifiedPurchaseOptimizeTTIMarketplace then
			v10 = nil
		end

		v13.alreadyOwned = getIsAlreadyOwned(v7, p2, bundle, v10)

		v13.isUserEligibleForUnifiedPurchaseFlow = getUnifiedPurchaseFlowEligibility(v7)
		v13.robloxSubscriptionProducts = getRobloxSubscriptionProducts(v7):catch(function(): nil
			return nil
		end)

		v13.cartPricingResponse = v12
		return all(v13):andThen(function(data)
			local v20 = p8

			if FFlagRefreshPriceOnRetryAfterUpsell and p9 then
				local refreshedExpectedPrice = data.bundleDetails.refreshedExpectedPrice

				if refreshedExpectedPrice ~= nil then
					v5(object, refreshedExpectedPrice)
					v20 = refreshedExpectedPrice
				end
			end

			if data.bundleDetails.product then
				if fFlagUnifiedPurchaseOptimizeTTIMarketplace then
					object:dispatch(resolveBundlePromptState(
						nil,
						data.bundleDetails,
						data.accountInfo,
						data.balanceInfo,
						v20,
						data.alreadyOwned,
						data.isUserEligibleForUnifiedPurchaseFlow,
						data.robloxSubscriptionProducts
					))
				else
					getProductPurchasableDetails(v7, data.bundleDetails.product.id):andThen(function(p11)
						object:dispatch(resolveBundlePromptState(
							p11,
							data.bundleDetails,
							data.accountInfo,
							data.balanceInfo,
							v20,
							data.alreadyOwned,
							data.isUserEligibleForUnifiedPurchaseFlow,
							data.robloxSubscriptionProducts
						))
					end)
				end
			else
				object:dispatch(ErrorOccurred(PurchaseError.NotForSale))
			end
		end):catch(function(p11)
			object:dispatch(ErrorOccurred(p11))
		end)
	end)
end

return initiateBundlePurchase
