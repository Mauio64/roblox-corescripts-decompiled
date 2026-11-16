local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local SharedFlags = require(parent.SharedFlags)

require(PurchasePrompt.Actions.SetABVariation)
local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local RequestAssetPurchase = require(PurchasePrompt.Actions.RequestAssetPurchase)
local RequestGamepassPurchase = require(PurchasePrompt.Actions.RequestGamepassPurchase)
local RequestProductPurchase = require(PurchasePrompt.Actions.RequestProductPurchase)
local SetPurchaseFlowUUID = require(PurchasePrompt.Actions.SetPurchaseFlowUUID)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
require(PurchasePrompt.Misc.Constants)
local Network = require(PurchasePrompt.Services.Network)

local deprecated_GetProductInfo = require(PurchasePrompt.Network.deprecated_GetProductInfo)
local getProductInfo = require(PurchasePrompt.Network.getProductInfo)
local getBalanceInfo = require(PurchasePrompt.Network.getBalanceInfo)
local getIsAlreadyOwned = require(PurchasePrompt.Network.getIsAlreadyOwned)
local ExternalSettings = require(PurchasePrompt.Services.ExternalSettings)
local hasPendingRequest = require(PurchasePrompt.Utils.hasPendingRequest)
local Promise = require(PurchasePrompt.Promise)
local Thunk = require(PurchasePrompt.Thunk)
local IxpServiceWrapper = require(parent.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper
local v = require(parent.AppCommonLib)
v = v.Logging
local LoggingProtocol = require(parent.LoggingProtocol)
local types = require(PurchasePrompt.types)
local productTypeEnum = types.ProductTypeEnum
local RequestExperiencePurchase = require(PurchasePrompt.Actions.RequestExperiencePurchase)
local RequestLookPurchase = require(PurchasePrompt.Actions.RequestLookPurchase)
local RequestRobuxUpsellPurchase = require(PurchasePrompt.Actions.RequestRobuxUpsellPurchase)
local RequestDeveloperSubscriptionPurchase = require(PurchasePrompt.Actions.RequestDeveloperSubscriptionPurchase)
local RequestVIPServerPurchase = require(PurchasePrompt.Actions.RequestVIPServerPurchase)

local SharedFlags2 = require(PurchasePrompt.Parent.SharedFlags)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = SharedFlags2.FFlagEnableUnifiedPurchaseFlowForDevSubs
local SetIsUserEligibleForUnifiedPurchaseFlow = require(PurchasePrompt.Actions.SetIsUserEligibleForUnifiedPurchaseFlow)
local SetPromptState = require(PurchasePrompt.Actions.SetPromptState)
local PromptState = require(PurchasePrompt.Enums.PromptState)

local SetProductPayload = require(PurchasePrompt.Actions.SetProductPayload)
local resolvePromptState = require(script.Parent.resolvePromptState)
local fetchCartPricing = require(script.Parent.fetchCartPricing)
local fetchInGameItemCartPricing = require(script.Parent.fetchInGameItemCartPricing)
local FFlagMockCartPricingResponseInStudio = require(PurchasePrompt.Flags.FFlagMockCartPricingResponseInStudio)
local buildProductPayloadFromInitiateArgs = require(PurchasePrompt.Utils.buildProductPayloadFromInitiateArgs)

local SharedFlags3 = require(PurchasePrompt.Parent.SharedFlags)
local FFlagEnableFetchCartPricingDuringInExperience = SharedFlags3.FFlagEnableFetchCartPricingDuringInExperience

local SharedFlags4 = require(PurchasePrompt.Parent.SharedFlags)
local FFlagAXFetchCartPricingDuringInExperienceExposure = SharedFlags4.FFlagAXFetchCartPricingDuringInExperienceExposure

local SharedFlags5 = require(PurchasePrompt.Parent.SharedFlags)
local FStringAXFetchCartPricingDuringInExperienceLayerName = SharedFlags5.FStringAXFetchCartPricingDuringInExperienceLayerName
local GetFFlagEnableCreatorStorePurchasingCutover = require(PurchasePrompt.Flags.GetFFlagEnableCreatorStorePurchasingCutover)
local FFlagEnablePurchaseFlowUUIDMigration = require(PurchasePrompt.Flags.FFlagEnablePurchaseFlowUUIDMigration)
local getUnifiedPurchaseFlowEligibility = require(PurchasePrompt.Network.getUnifiedPurchaseFlowEligibility)
local FFlagFixPurchasingErrorCounter = require(PurchasePrompt.Flags.FFlagFixPurchasingErrorCounter)
local FFlagRefreshPriceOnRetryAfterUpsell = require(PurchasePrompt.Flags.FFlagRefreshPriceOnRetryAfterUpsell)
local defineFastFlag = game:DefineFastFlag("RefreshDevSubPriceOnRetryAfterUpsell2", false)
local FFlagRefreshLookPriceOnRetryAfterUpsell = require(PurchasePrompt.Flags.FFlagRefreshLookPriceOnRetryAfterUpsell)
local applyRefreshedPrice

if FFlagRefreshPriceOnRetryAfterUpsell or FFlagRefreshLookPriceOnRetryAfterUpsell then
	applyRefreshedPrice = require(PurchasePrompt.Utils.applyRefreshedPrice)
else
	applyRefreshedPrice = nil
end

local SharedFlags6 = require(PurchasePrompt.Parent.SharedFlags)
local FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = SharedFlags6.FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow

local SharedFlags7 = require(PurchasePrompt.Parent.SharedFlags)
local FFlagAddPurchaseOptionForProvidingBalance = SharedFlags7.FFlagAddPurchaseOptionForProvidingBalance

local SharedFlags8 = require(PurchasePrompt.Parent.SharedFlags)
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags8.FFlagLuaAppsEnablePromptVIPServerPurchase
local SharedFlags9 = require(PurchasePrompt.Parent.SharedFlags)
local FFlagUnifiedPurchaseAddSkeleton = SharedFlags9.FFlagUnifiedPurchaseAddSkeleton
local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local FFlagEnableInExperiencePurchaseModalMetrics = require(PurchasePrompt.Flags.FFlagEnableInExperiencePurchaseModalMetrics)
local trackInExperiencePurchaseStart = require(PurchasePrompt.Utils.trackInExperiencePurchaseStart)
local AppContext = require(PurchasePrompt.Utils.AppContext)

local RobloxSubscriptionPurchaseApp = require(parent.RobloxSubscriptionPurchaseApp)
local getRobloxSubscriptionProducts = RobloxSubscriptionPurchaseApp.Network.getRobloxSubscriptionProducts

local PurchaseFlowUUIDTelemetry = require(PurchasePrompt.Events.PurchaseFlowUUIDTelemetry)

local v2 = { Network, ExternalSettings }

local function initiatePurchase(subscriptionId, p, p2, p3, p4, p5, collectibleItemId, collectibleItemInstanceId, p6, p7, p8, p9)
	return Thunk.new(script.Name, v2, function(object, p10)
		local v3 = p10[Network]
		local v4 = p10[ExternalSettings]

		if hasPendingRequest(object:getState()) and not p9 then
			return nil
		end

		if FFlagEnablePurchaseFlowUUIDMigration then
			object:dispatch(SetPurchaseFlowUUID((HttpService:GenerateGUID(false))))

			LoggingProtocol.default:logRobloxTelemetryCounter(PurchaseFlowUUIDTelemetry.InitiatePurchaseCounter, 1, {
				method = "initiatePurchase"
			})
		end

		if p == Enum.InfoType.Asset then
			object:dispatch(RequestAssetPurchase(
				subscriptionId,
				p2,
				p3,
				p4,
				p5,
				collectibleItemId,
				collectibleItemInstanceId,
				p6,
				p7
			))
		elseif p == Enum.InfoType.GamePass then
			object:dispatch(RequestGamepassPurchase(subscriptionId, p4))
		elseif p == Enum.InfoType.Product then
			object:dispatch(RequestProductPurchase(subscriptionId, p2, p4))
		elseif p == productTypeEnum.Experience then
			object:dispatch(RequestExperiencePurchase(subscriptionId))
		elseif p == productTypeEnum.Look then
			object:dispatch(RequestLookPurchase(subscriptionId))
		elseif FFlagEnableUnifiedPurchaseFlowForDevSubs and p == productTypeEnum.DeveloperSubscription then
			object:dispatch(RequestDeveloperSubscriptionPurchase(subscriptionId, p7))
		elseif FFlagAXMISWithBlackbird and p == productTypeEnum.RobuxUpsell then
			object:dispatch(RequestRobuxUpsellPurchase())
		elseif p == productTypeEnum.VIPServer then
			object:dispatch(RequestVIPServerPurchase())
		else
			assert(false, "Invalid product type")
			return nil
		end

		if v4.getFlagOrder66() then
			object:dispatch(ErrorOccurred(PurchaseError.PurchaseDisabled))
			return nil
		end

		if FFlagLuaAppsEnablePromptVIPServerPurchase and p == productTypeEnum.VIPServer and v4.isStudio() then
			object:dispatch(ErrorOccurred(PurchaseError.UnsupportedInStudio))
			return nil
		end

		if FFlagEnableInExperiencePurchaseModalMetrics and not p9 then
			trackInExperiencePurchaseStart(object)
		end

		local v5 = nil
		local providedRobuxBalance = nil
		local v6 = nil

		if FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow then
			local purchaseOptions = object:getState().purchaseOptions
			v5 = purchaseOptions ~= nil and purchaseOptions.shouldSkipOwnershipCheck == true or v5

			if
				FFlagAddPurchaseOptionForProvidingBalance
				and purchaseOptions ~= nil
				and purchaseOptions.providedRobuxBalance ~= nil
			then
				providedRobuxBalance = purchaseOptions.providedRobuxBalance
			end

			if
				FFlagUnifiedPurchaseAddSkeleton
				and purchaseOptions ~= nil
				and purchaseOptions.enablePreloadedPurchaseUI == true
			then
				v6 = true
			end
		end

		local purchaseCallbacks = object:getState().purchaseCallbacks
		local fetchProductInfo

		if not (purchaseCallbacks == nil or purchaseCallbacks.fetchProductInfo == nil) then
			fetchProductInfo = purchaseCallbacks.fetchProductInfo
		end

		local v7 = p8

		if FFlagUnifiedPurchaseAddSkeleton and v6 then
			object:dispatch(SetIsUserEligibleForUnifiedPurchaseFlow(true))
			object:dispatch(SetPromptState(PromptState.InitializingPurchase))
		end

		local v8

		if FFlagRefreshPriceOnRetryAfterUpsell and p9 then
			local productPayload = object:getState().productPayload
			v8 = {
				collectibleItemId = collectibleItemId,
				collectibleItemInstanceId = collectibleItemInstanceId,
				timedOptionDays = 0
			}
			local timedOptionDays

			if productPayload then
				timedOptionDays = productPayload.timedOptionDays
			end

			v8.timedOptionDays = timedOptionDays
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
			and p == Enum.InfoType.Asset
			and not (object:getState().purchaseOptions.shouldFetchCartPricing or p9)
		then
			IXPServiceWrapper:LogFlagLinkedUserLayerExposure(FStringAXFetchCartPricingDuringInExperienceLayerName)
		end

		local fn = FFlagEnableFetchCartPricingDuringInExperience
			and p == Enum.InfoType.Asset
			and not (object:getState().purchaseOptions.shouldFetchCartPricing or p9)
			and function(p11)
				return object:dispatch(fetchCartPricing(nil, p11))
			end
			or nil

		local v9 = FFlagMockCartPricingResponseInStudio and v4.isStudio()
			or AppContext.get() == AppContext.Enum.IN_EXPERIENCE
		local inGameItemCartPricingResponse

		if (p == Enum.InfoType.GamePass or p == Enum.InfoType.Product) and v9 then
			inGameItemCartPricingResponse = object:dispatch(fetchInGameItemCartPricing())
		end

		local all = Promise.all
		local productInfo

		if GetFFlagEnableCreatorStorePurchasingCutover() then
			if fetchProductInfo == nil or p9 then
				if not FFlagRefreshPriceOnRetryAfterUpsell then
					v8 = nil
				end

				if not FFlagEnableFetchCartPricingDuringInExperience then
					fn = nil
				end

				productInfo = getProductInfo(v3, subscriptionId, p, v7, v8, fn)
			else
				productInfo = fetchProductInfo()
			end
		else
			productInfo = deprecated_GetProductInfo(v3, subscriptionId, p)
		end

		return all({
			productInfo = productInfo,
			accountInfo = Promise.resolve({
				isPremium = Players.LocalPlayer.MembershipType == Enum.MembershipType.Premium
			}),
			alreadyOwned = getIsAlreadyOwned(v3, subscriptionId, p, v5),
			balanceInfo = getBalanceInfo(v3, v4, false, true, providedRobuxBalance),
			isUserEligibleForUnifiedPurchaseFlow = getUnifiedPurchaseFlowEligibility(v3, p),
			robloxSubscriptionProducts = getRobloxSubscriptionProducts():catch(function(): nil
				return nil
			end),
			cartPricingResponse = cartPricingResponse,
			inGameItemCartPricingResponse = inGameItemCartPricingResponse
		}):andThen(function(data)
			if
				FFlagEnableUnifiedPurchaseFlowForDevSubs
				and data.productInfo.ProductType == productTypeEnum.DeveloperSubscription
				and (object:getState().productPayload == nil or object:getState().productPayload.kind == nil)
			then
				object:dispatch(SetProductPayload({
					subscriptionId = subscriptionId,
					kind = productTypeEnum.DeveloperSubscription,
					expectedPrice = data.productInfo.PriceInRobux,
					iconImageAssetId = data.productInfo.IconImageAssetId,
					isSubscriptionInRobux = data.productInfo.PriceInRobux ~= nil and data.productInfo.PriceInRobux > 0
				}))
			end

			local productPayload = object:getState().productPayload
			local v10 = not (productPayload and productPayload.kind)
				and buildProductPayloadFromInitiateArgs(
					subscriptionId,
					p,
					p2,
					p3,
					p4,
					p5,
					collectibleItemId,
					collectibleItemInstanceId,
					p6,
					p7,
					v7
				)

			if v10 then
				object:dispatch(SetProductPayload(v10))
			end

			local v11 = p7

			if (FFlagRefreshPriceOnRetryAfterUpsell or FFlagRefreshLookPriceOnRetryAfterUpsell) and p9 then
				local v12 = data.productInfo.refreshedExpectedPrice

				if
					defineFastFlag
					and FFlagEnableUnifiedPurchaseFlowForDevSubs
					and data.productInfo.ProductType == productTypeEnum.DeveloperSubscription
				then
					v12 = data.productInfo.PriceInRobux
				end

				if v12 ~= nil then
					applyRefreshedPrice(object, v12)
					v11 = v12
				end
			end

			object:dispatch(resolvePromptState(
				data.productInfo,
				data.accountInfo,
				data.balanceInfo,
				data.alreadyOwned,
				p3,
				v11,
				data.isUserEligibleForUnifiedPurchaseFlow,
				data.robloxSubscriptionProducts
			))
		end):catch(function(p11)
			if not FFlagFixPurchasingErrorCounter then
				object:dispatch(ErrorOccurred(p11))
			elseif PurchaseError.isMember(p11) then
				object:dispatch(ErrorOccurred(p11))
			else
				object:dispatch(ErrorOccurred(PurchaseError.UnknownFailure))
			end
		end)
	end)
end

return initiatePurchase
