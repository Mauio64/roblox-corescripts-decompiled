local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags")

require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetABVariation")
local ErrorOccurred = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/ErrorOccurred")
local RequestAssetPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RequestAssetPurchase")
local RequestGamepassPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RequestGamepassPurchase")
local RequestProductPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RequestProductPurchase")
local SetPurchaseFlowUUID = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPurchaseFlowUUID")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Misc/Constants")
local Network = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Network")

local deprecated_GetProductInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/deprecated_GetProductInfo")
local getProductInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getProductInfo")
local getBalanceInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getBalanceInfo")
local getIsAlreadyOwned = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getIsAlreadyOwned")
local ExternalSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/ExternalSettings")
local hasPendingRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/hasPendingRequest")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")
local ixpServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IxpServiceWrapper").IXPServiceWrapper
local logging = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/AppCommonLib").Logging
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/LoggingProtocol")
local productTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types").ProductTypeEnum
local RequestExperiencePurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RequestExperiencePurchase")
local RequestLookPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RequestLookPurchase")
local RequestRobuxUpsellPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RequestRobuxUpsellPurchase")
local RequestDeveloperSubscriptionPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RequestDeveloperSubscriptionPurchase")
local RequestVIPServerPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/RequestVIPServerPurchase")

local fFlagEnableUnifiedPurchaseFlowForDevSubs = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableUnifiedPurchaseFlowForDevSubs
local SetIsUserEligibleForUnifiedPurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetIsUserEligibleForUnifiedPurchaseFlow")
local SetPromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPromptState")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")

local SetProductPayload = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetProductPayload")
local resolvePromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/resolvePromptState")
local fetchCartPricing = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/fetchCartPricing")
local fetchInGameItemCartPricing = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/fetchInGameItemCartPricing")
local FFlagMockCartPricingResponseInStudio = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagMockCartPricingResponseInStudio")
local buildProductPayloadFromInitiateArgs = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/buildProductPayloadFromInitiateArgs")

local fFlagEnableFetchCartPricingDuringInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableFetchCartPricingDuringInExperience

local fFlagAXFetchCartPricingDuringInExperienceExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagAXFetchCartPricingDuringInExperienceExposure

local fStringAXFetchCartPricingDuringInExperienceLayerName = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FStringAXFetchCartPricingDuringInExperienceLayerName
local GetFFlagEnableCreatorStorePurchasingCutover = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagEnableCreatorStorePurchasingCutover")
local FFlagEnablePurchaseFlowUUIDMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagEnablePurchaseFlowUUIDMigration")
local getUnifiedPurchaseFlowEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getUnifiedPurchaseFlowEligibility")
local FFlagFixPurchasingErrorCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagFixPurchasingErrorCounter")
local FFlagRefreshPriceOnRetryAfterUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagRefreshPriceOnRetryAfterUpsell")
local defineFastFlag = game:DefineFastFlag("RefreshDevSubPriceOnRetryAfterUpsell2", false)
local FFlagRefreshLookPriceOnRetryAfterUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagRefreshLookPriceOnRetryAfterUpsell")

local v5 = if FFlagRefreshPriceOnRetryAfterUpsell or FFlagRefreshLookPriceOnRetryAfterUpsell then require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/applyRefreshedPrice") else nil

local fFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow

local fFlagAddPurchaseOptionForProvidingBalance = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagAddPurchaseOptionForProvidingBalance

local fFlagLuaAppsEnablePromptVIPServerPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagLuaAppsEnablePromptVIPServerPurchase
local fFlagUnifiedPurchaseAddSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagUnifiedPurchaseAddSkeleton
local fFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local FFlagEnableInExperiencePurchaseModalMetrics = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagEnableInExperiencePurchaseModalMetrics")
local trackInExperiencePurchaseStart = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/trackInExperiencePurchaseStart")
local AppContext = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/AppContext")

local getRobloxSubscriptionProducts = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/RobloxSubscriptionPurchaseApp").Network.getRobloxSubscriptionProducts

local PurchaseFlowUUIDTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Events/PurchaseFlowUUIDTelemetry")

local v6 = { Network, ExternalSettings }

local function initiatePurchase(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13)
	return Thunk.new("initiatePurchase", v6, function(object, p14)
		local v7 = p14[Network]
		local v8 = p14[ExternalSettings]

		if hasPendingRequest(object:getState()) and not p13 then
			return nil
		end

		if FFlagEnablePurchaseFlowUUIDMigration then
			object:dispatch(SetPurchaseFlowUUID((HttpService:GenerateGUID(false))))

			LoggingProtocol.default:logRobloxTelemetryCounter(PurchaseFlowUUIDTelemetry.InitiatePurchaseCounter, 1, {
				method = "initiatePurchase"
			})
		end

		if p3 == Enum.InfoType.Asset then
			object:dispatch(RequestAssetPurchase(p2, p4, p5, p6, p7, p8, p9, p10, p11))
		elseif p3 == Enum.InfoType.GamePass then
			object:dispatch(RequestGamepassPurchase(p2, p6))
		elseif p3 == Enum.InfoType.Product then
			object:dispatch(RequestProductPurchase(p2, p4, p6))
		elseif p3 == productTypeEnum.Experience then
			object:dispatch(RequestExperiencePurchase(p2))
		elseif p3 == productTypeEnum.Look then
			object:dispatch(RequestLookPurchase(p2))
		elseif fFlagEnableUnifiedPurchaseFlowForDevSubs and p3 == productTypeEnum.DeveloperSubscription then
			object:dispatch(RequestDeveloperSubscriptionPurchase(p2, p11))
		elseif fFlagAXMISWithBlackbird and p3 == productTypeEnum.RobuxUpsell then
			object:dispatch(RequestRobuxUpsellPurchase())
		elseif p3 == productTypeEnum.VIPServer then
			object:dispatch(RequestVIPServerPurchase())
		else
			assert(false, "Invalid product type")
			return nil
		end

		if v8.getFlagOrder66() then
			object:dispatch(ErrorOccurred(PurchaseError.PurchaseDisabled))
			return nil
		end

		if
			fFlagLuaAppsEnablePromptVIPServerPurchase
			and p3 == productTypeEnum.VIPServer
			and v8.isStudio()
		then
			object:dispatch(ErrorOccurred(PurchaseError.UnsupportedInStudio))
			return nil
		end

		if FFlagEnableInExperiencePurchaseModalMetrics and not p13 then
			trackInExperiencePurchaseStart(object)
		end

		local v9 = nil
		local providedRobuxBalance = nil
		local v10 = nil

		if fFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow then
			local purchaseOptions = object:getState().purchaseOptions
			v9 = purchaseOptions ~= nil and purchaseOptions.shouldSkipOwnershipCheck == true or v9

			if
				fFlagAddPurchaseOptionForProvidingBalance
				and purchaseOptions ~= nil
				and purchaseOptions.providedRobuxBalance ~= nil
			then
				providedRobuxBalance = purchaseOptions.providedRobuxBalance
			end

			if
				fFlagUnifiedPurchaseAddSkeleton
				and purchaseOptions ~= nil
				and purchaseOptions.enablePreloadedPurchaseUI == true
			then
				v10 = true
			end
		end

		local purchaseCallbacks = object:getState().purchaseCallbacks
		local fetchProductInfo

		if not (purchaseCallbacks == nil or purchaseCallbacks.fetchProductInfo == nil) then
			fetchProductInfo = purchaseCallbacks.fetchProductInfo
		end

		local v11 = p12

		if fFlagUnifiedPurchaseAddSkeleton and v10 then
			object:dispatch(SetIsUserEligibleForUnifiedPurchaseFlow(true))
			object:dispatch(SetPromptState(PromptState.InitializingPurchase))
		end

		local v12

		if FFlagRefreshPriceOnRetryAfterUpsell and p13 then
			local productPayload = object:getState().productPayload
			v12 = {
				collectibleItemId = p8,
				collectibleItemInstanceId = p9,
				timedOptionDays = 0
			}

			local v13 = if productPayload then productPayload.timedOptionDays else nil
			v12.timedOptionDays = v13
		end

		local v13

		if fFlagEnableFetchCartPricingDuringInExperience then
			if object:getState().purchaseOptions.shouldFetchCartPricing then
				v13 = object:dispatch(fetchCartPricing())
			end
		else
			v13 = object:dispatch(fetchCartPricing())
		end

		if
			fFlagAXFetchCartPricingDuringInExperienceExposure
			and p3 == Enum.InfoType.Asset
			and not (object:getState().purchaseOptions.shouldFetchCartPricing or p13)
		then
			ixpServiceWrapper:LogFlagLinkedUserLayerExposure(fStringAXFetchCartPricingDuringInExperienceLayerName)
		end

		local fn = fFlagEnableFetchCartPricingDuringInExperience
			and p3 == Enum.InfoType.Asset
			and not (object:getState().purchaseOptions.shouldFetchCartPricing or p13)
			and function(p15)
				return object:dispatch(fetchCartPricing(nil, p15))
			end
			or nil

		local v14 = FFlagMockCartPricingResponseInStudio and v8.isStudio() or AppContext.get() == AppContext.Enum.IN_EXPERIENCE
		local v15

		if (p3 == Enum.InfoType.GamePass or p3 == Enum.InfoType.Product) and v14 then
			v15 = object:dispatch(fetchInGameItemCartPricing())
		end

		local all = Promise.all
		local v17

		if GetFFlagEnableCreatorStorePurchasingCutover() then
			if fetchProductInfo == nil or p13 then
				if not FFlagRefreshPriceOnRetryAfterUpsell then
					v12 = nil
				end

				if not fFlagEnableFetchCartPricingDuringInExperience then
					fn = nil
				end

				v17 = getProductInfo(v7, p2, p3, v11, v12, fn)
			else
				v17 = fetchProductInfo()
			end
		else
			v17 = deprecated_GetProductInfo(v7, p2, p3)
		end

		return all({
			productInfo = v17,
			accountInfo = Promise.resolve({
				isPremium = Players.LocalPlayer.MembershipType == Enum.MembershipType.Premium
			}),
			alreadyOwned = getIsAlreadyOwned(v7, p2, p3, v9),
			balanceInfo = getBalanceInfo(v7, v8, false, true, providedRobuxBalance),
			isUserEligibleForUnifiedPurchaseFlow = getUnifiedPurchaseFlowEligibility(v7, p3),
			robloxSubscriptionProducts = getRobloxSubscriptionProducts():catch(function(): nil
				return nil
			end),
			cartPricingResponse = v13,
			inGameItemCartPricingResponse = v15
		}):andThen(function(data)
			if
				fFlagEnableUnifiedPurchaseFlowForDevSubs
				and data.productInfo.ProductType == productTypeEnum.DeveloperSubscription
				and (object:getState().productPayload == nil or object:getState().productPayload.kind == nil)
			then
				object:dispatch(SetProductPayload({
					subscriptionId = p2,
					kind = productTypeEnum.DeveloperSubscription,
					expectedPrice = data.productInfo.PriceInRobux,
					iconImageAssetId = data.productInfo.IconImageAssetId,
					isSubscriptionInRobux = data.productInfo.PriceInRobux ~= nil and data.productInfo.PriceInRobux > 0
				}))
			end

			local productPayload = object:getState().productPayload
			local v18 = not (productPayload and productPayload.kind)
				and buildProductPayloadFromInitiateArgs(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, v11)

			if v18 then
				object:dispatch(SetProductPayload(v18))
			end

			local v19 = p11

			if (FFlagRefreshPriceOnRetryAfterUpsell or FFlagRefreshLookPriceOnRetryAfterUpsell) and p13 then
				local v20 = data.productInfo.refreshedExpectedPrice

				if
					defineFastFlag
					and fFlagEnableUnifiedPurchaseFlowForDevSubs
					and data.productInfo.ProductType == productTypeEnum.DeveloperSubscription
				then
					v20 = data.productInfo.PriceInRobux
				end

				if v20 ~= nil then
					v5(object, v20)
					v19 = v20
				end
			end

			object:dispatch(resolvePromptState(
				data.productInfo,
				data.accountInfo,
				data.balanceInfo,
				data.alreadyOwned,
				p5,
				v19,
				data.isUserEligibleForUnifiedPurchaseFlow,
				data.robloxSubscriptionProducts
			))
		end):catch(function(p15)
			if not FFlagFixPurchasingErrorCounter then
				object:dispatch(ErrorOccurred(p15))
			elseif PurchaseError.isMember(p15) then
				object:dispatch(ErrorOccurred(p15))
			else
				object:dispatch(ErrorOccurred(PurchaseError.UnknownFailure))
			end
		end)
	end)
end

return initiatePurchase
