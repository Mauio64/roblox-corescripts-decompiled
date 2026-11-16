local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ExperienceAuthService = game:GetService("ExperienceAuthService")

local IAPExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")
local isEconomicRestrictionResponse = IAPExperience.Utility.isEconomicRestrictionResponse
local parseEconomicRestrictionsFailureReason = IAPExperience.Utility.parseEconomicRestrictionsFailureReason

local parseEconomicRestrictionsExpirationTimeInMinutes = IAPExperience.Utility.parseEconomicRestrictionsExpirationTimeInMinutes

local SetPromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetPromptState")
local StartPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/StartPurchase")
local ErrorOccurred = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/ErrorOccurred")
local SetEconomicRestrictionError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Actions/SetEconomicRestrictionError")
local PurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseFlow")
local PromptState = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PromptState")
local ItemType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/ItemType")
local PurchaseError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/PurchaseError")
local RequestType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/RequestType")
local getToolAsset = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/getToolAsset")
local performPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/performPurchase")
local performPurchaseV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/performPurchaseV2")
local performCreatorStorePurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Network/performCreatorStorePurchase")
local Network = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Network")
local Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Analytics")
local ExternalSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/ExternalSettings")
local isCreatorStoreAssetType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/isCreatorStoreAssetType")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")
local productTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types").ProductTypeEnum
local selectProductPrice = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Selectors/selectProductPrice")
local derivePurchaseOptionsFromCartPricingResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/derivePurchaseOptionsFromCartPricingResponse")
local mergeOfferIdsIntoPurchasePayload = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/mergeOfferIdsIntoPurchasePayload")

local performLuaPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/performLuaPurchase")
local handlePriceChangedError = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/handlePriceChangedError")

local completePurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunks/completePurchase")
local GetFFlagEnableCreatorStorePurchasingCutover = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagEnableCreatorStorePurchasingCutover")
local logUnifiedPurchaseTelemetryCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/logUnifiedPurchaseTelemetryCounter")
local reportPurchasePromptNonCollectiblePurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Telemetry/reportPurchasePromptNonCollectiblePurchase")
local UnifiedPurchaseTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Events/UnifiedPurchaseTelemetry")

local fFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow

local fFlagEnablePurchasePayloadInExperienceShop = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnablePurchasePayloadInExperienceShop
local fFlagEnableUnifiedPurchaseFlowForDevSubs = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagMockDevSubPurchaseInStudio = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagMockDevSubPurchaseInStudio")

local fFlagEnableMarketplacePurchaseDeepLinkAttribution = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableMarketplacePurchaseDeepLinkAttribution

local fFlagEnableNonCollectiblePurchaseCountersLua = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableNonCollectiblePurchaseCountersLua

local fFlagLuaAppsEnablePromptVIPServerPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagLuaAppsEnablePromptVIPServerPurchase

local v5 = { Network, Analytics, ExternalSettings }

function LUAUFORGE_MODULE_GLOBALS_bgm_isLuaPurchase(p2)
	if p2 == nil then
		return false
	end

	return (p2.kind == productTypeEnum.Product and p2.universeId ~= nil or p2.kind == productTypeEnum.Experience or p2.kind == productTypeEnum.Look or fFlagEnableUnifiedPurchaseFlowForDevSubs and p2.kind == productTypeEnum.DeveloperSubscription)
		and true
		or fFlagLuaAppsEnablePromptVIPServerPurchase and p2.kind == productTypeEnum.VIPServer
end

local function purchaseItem()
	return Thunk.new("purchaseItem", v5, function(object, p2)
		local v6 = p2[Network]
		local v7 = p2[ExternalSettings]
		local v8 = p2[Analytics]

		local state = object:getState()
		local purchaseFlow = state.purchaseFlow
		local requestType = state.promptRequest.requestType

		if state.cartPricing == nil or not state.cartPricing.isFetching then
			local platform = v7.getPlatform()

			object:dispatch(StartPurchase(Workspace.DistributedGameTime))

			if object:getState().isUserEligibleForUnifiedPurchaseFlow then
				logUnifiedPurchaseTelemetryCounter(
					UnifiedPurchaseTelemetry.UnifiedProductPurchaseModalPurchaseAttemptedCounter,
					state.purchaseAnalyticsMetadata.surface,
					state.purchaseAnalyticsMetadata.productType
				)

				if state.purchaseCallbacks and state.purchaseCallbacks.onPurchaseAttempt then
					state.purchaseCallbacks.onPurchaseAttempt()
				end
			end

			if requestType == RequestType.AvatarCreationFee then
				local v9 = {}
				v9.avatarName = state.productInfo.name
				v9.avatarDescription = state.productInfo.description
				v9.priceFromToken = state.productInfo.price

				local v10 = { Enum.ExperienceAuthScope.CreatorAssetsCreate }

				ExperienceAuthService:ScopeCheckUIComplete(
					state.promptRequest.id,
					v10,
					Enum.ScopeCheckResult.ConsentAccepted,
					v9
				)

				v8.signalAvatarCreationPurchaseSubmit()

				object:dispatch(completePurchase())
			else
				if purchaseFlow == PurchaseFlow.RobuxUpsellV2 or purchaseFlow == PurchaseFlow.LargeRobuxUpsell then
					object:dispatch(SetPromptState(PromptState.PurchaseInProgress))
				end

				local state2 = object:getState()

				local guid = HttpService:GenerateGUID(false)

				local id = state2.promptRequest.id
				local infoType = state2.promptRequest.infoType
				local equipIfPurchased = state2.promptRequest.equipIfPurchased
				local isRobloxPurchase = state2.promptRequest.isRobloxPurchase
				local purchaseAuthToken = state2.promptRequest.purchaseAuthToken
				local idempotencyKey = state2.promptRequest.idempotencyKey
				local collectibleItemId = state2.promptRequest.collectibleItemId
				local collectibleItemInstanceId = state2.promptRequest.collectibleItemInstanceId
				local collectibleProductId = state2.promptRequest.collectibleProductId
				local v9 = selectProductPrice(state2)
				local assetTypeId = state2.productInfo.assetTypeId
				local assetType = state2.productInfo.assetType
				local productId = state2.productInfo.productId
				local collectibleItemId2 = state2.productInfo.collectibleItemId
				local collectibleProductId2 = state2.productInfo.collectibleProductId

				local v10 = derivePurchaseOptionsFromCartPricingResponse(state2.cartPricing and state2.cartPricing.response)

				if fFlagEnableMarketplacePurchaseDeepLinkAttribution then
					local deepLinkId = state2.productPayload and state2.productPayload.deepLinkId

					if deepLinkId ~= nil and deepLinkId ~= "" then
						v10 = v10 or {}
						v10.DeepLinkId = deepLinkId
					end
				end

				local itemType = state2.productInfo.itemType

				v8.signalProductPurchaseConfirmed(productId, state2.requestType)
				local v11

				if collectibleItemId then
					v11 = not (collectibleItemId == "") and infoType == Enum.InfoType.Bundle
				else
					v11 = collectibleItemId
				end

				if LUAUFORGE_MODULE_GLOBALS_bgm_isLuaPurchase(state2.productPayload) then
					if
						FFlagMockDevSubPurchaseInStudio
						and fFlagEnableUnifiedPurchaseFlowForDevSubs
						and state2.productPayload.kind == productTypeEnum.DeveloperSubscription
						and v7.isStudio()
					then
						object:dispatch(completePurchase())
					else
						object:dispatch(performLuaPurchase())
					end
				else
					if GetFFlagEnableCreatorStorePurchasingCutover() and isCreatorStoreAssetType(assetType) then
						return performCreatorStorePurchase(v6, productId, assetType):andThen(function(p3)
							object:dispatch(completePurchase())

							v8.signalPurchaseSuccess(id, infoType, v9, p3)

							return Promise.resolve()
						end):catch(function(p3)
							object:dispatch(ErrorOccurred(p3))
						end)
					end

					if v11 or collectibleItemInstanceId and collectibleItemInstanceId ~= "" then
						return performPurchaseV2(
							v6,
							infoType,
							productId,
							v9,
							guid,
							isRobloxPurchase,
							collectibleItemId,
							collectibleProductId,
							idempotencyKey,
							purchaseAuthToken,
							collectibleItemInstanceId,
							v10
						):andThen(function(p3)
							object:dispatch(completePurchase(p3))

							v8.signalPurchaseSuccess(id, infoType, v9, p3)

							return Promise.resolve()
						end):catch(function(p3)
							if isEconomicRestrictionResponse(p3) then
								object:dispatch(SetEconomicRestrictionError(
									parseEconomicRestrictionsFailureReason(p3),
									(parseEconomicRestrictionsExpirationTimeInMinutes(p3))
								))
								object:dispatch(ErrorOccurred(PurchaseError.EconomicRestriction))
							else
								if handlePriceChangedError(
									object,
									p3,
									state2.productPayload and state2.productPayload.kind
								) then
									return
								end

								if p3 == PurchaseError.TwoFactorNeeded then
									v8.signalTwoSVSettingsErrorShown(productId, infoType)

									if
										platform == Enum.Platform.Windows
										or platform == Enum.Platform.OSX
									then
										p3 = PurchaseError.TwoFactorNeededSettings
									end
								end

								object:dispatch(ErrorOccurred(p3))
							end
						end)
					end

					if
						fFlagEnableNonCollectiblePurchaseCountersLua
						and (collectibleItemId2 == nil or collectibleItemId2 == "")
					then
						reportPurchasePromptNonCollectiblePurchase(infoType, state2.productInfo)
					end

					local timedOptionDays

					if fFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow then
						timedOptionDays = state2.productPayload and state2.productPayload.timedOptionDays
					end

					local v12

					if fFlagEnablePurchasePayloadInExperienceShop then
						local purchasePayload = state2.productPayload
							and state2.productPayload.purchasePayload
						v12 = mergeOfferIdsIntoPurchasePayload(purchasePayload, v10)
					end

					if not fFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow then
						timedOptionDays = nil
					end

					if not fFlagEnablePurchasePayloadInExperienceShop then
						v12 = nil
					end

					return performPurchase(
						v6,
						infoType,
						productId,
						v9,
						guid,
						isRobloxPurchase,
						collectibleItemId2,
						collectibleProductId2,
						idempotencyKey,
						purchaseAuthToken,
						timedOptionDays,
						v12,
						v10
					):andThen(function(p3)
						object:dispatch(completePurchase(p3))

						if itemType ~= ItemType.Bundle then
							v8.signalPurchaseSuccess(id, infoType, v9, p3)
						end

						if equipIfPurchased and assetTypeId == 19 then
							return getToolAsset(v6, id):andThen(function(p4)
								if p4 then
									p4.Parent = Players.LocalPlayer.Backpack
								end
							end)
						end

						return Promise.resolve()
					end):catch(function(p3)
						if isEconomicRestrictionResponse(p3) then
							object:dispatch(SetEconomicRestrictionError(
								parseEconomicRestrictionsFailureReason(p3),
								(parseEconomicRestrictionsExpirationTimeInMinutes(p3))
							))
							object:dispatch(ErrorOccurred(PurchaseError.EconomicRestriction))
						else
							if handlePriceChangedError(object, p3, state2.productPayload and state2.productPayload.kind) then
								return
							end

							if p3 == PurchaseError.TwoFactorNeeded then
								v8.signalTwoSVSettingsErrorShown(productId, infoType)

								if platform == Enum.Platform.Windows or platform == Enum.Platform.OSX then
									p3 = PurchaseError.TwoFactorNeededSettings
								end
							end

							object:dispatch(ErrorOccurred(p3))
						end
					end)
				end
			end
		else
			local purchaseAnalyticsMetadata = state.purchaseAnalyticsMetadata
			logUnifiedPurchaseTelemetryCounter(
				UnifiedPurchaseTelemetry.UnifiedCartPricingBuyBlockedWhileFetchingCounter,
				purchaseAnalyticsMetadata and purchaseAnalyticsMetadata.surface,
				purchaseAnalyticsMetadata and purchaseAnalyticsMetadata.productType
			)
		end
	end)
end

return purchaseItem
