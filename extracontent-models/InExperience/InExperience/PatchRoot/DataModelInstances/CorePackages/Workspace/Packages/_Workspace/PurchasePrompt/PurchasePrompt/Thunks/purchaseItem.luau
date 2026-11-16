local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ExperienceAuthService = game:GetService("ExperienceAuthService")

local parent = PurchasePrompt.Parent
local IAPExperience = require(parent.IAPExperience)
local isEconomicRestrictionResponse = IAPExperience.Utility.isEconomicRestrictionResponse
local parseEconomicRestrictionsFailureReason = IAPExperience.Utility.parseEconomicRestrictionsFailureReason

local parseEconomicRestrictionsExpirationTimeInMinutes = IAPExperience.Utility.parseEconomicRestrictionsExpirationTimeInMinutes

local SetPromptState = require(PurchasePrompt.Actions.SetPromptState)
local StartPurchase = require(PurchasePrompt.Actions.StartPurchase)
local ErrorOccurred = require(PurchasePrompt.Actions.ErrorOccurred)
local SetEconomicRestrictionError = require(PurchasePrompt.Actions.SetEconomicRestrictionError)
local PurchaseFlow = require(PurchasePrompt.Enums.PurchaseFlow)
local PromptState = require(PurchasePrompt.Enums.PromptState)
local ItemType = require(PurchasePrompt.Enums.ItemType)
local PurchaseError = require(PurchasePrompt.Enums.PurchaseError)
local RequestType = require(PurchasePrompt.Enums.RequestType)
local getToolAsset = require(PurchasePrompt.Network.getToolAsset)
local performPurchase = require(PurchasePrompt.Network.performPurchase)
local performPurchaseV2 = require(PurchasePrompt.Network.performPurchaseV2)
local performCreatorStorePurchase = require(PurchasePrompt.Network.performCreatorStorePurchase)
local Network = require(PurchasePrompt.Services.Network)
local Analytics = require(PurchasePrompt.Services.Analytics)
local ExternalSettings = require(PurchasePrompt.Services.ExternalSettings)
local isCreatorStoreAssetType = require(PurchasePrompt.Utils.isCreatorStoreAssetType)
local Thunk = require(PurchasePrompt.Thunk)
local Promise = require(PurchasePrompt.Promise)
require(PurchasePrompt.types)
local types = require(PurchasePrompt.types)
local productTypeEnum = types.ProductTypeEnum
local selectProductPrice = require(PurchasePrompt.Selectors.selectProductPrice)
local derivePurchaseOptionsFromCartPricingResponse = require(PurchasePrompt.Utils.derivePurchaseOptionsFromCartPricingResponse)
local mergeOfferIdsIntoPurchasePayload = require(PurchasePrompt.Utils.mergeOfferIdsIntoPurchasePayload)

local performLuaPurchase = require(PurchasePrompt.Thunks.performLuaPurchase)
local handlePriceChangedError = require(PurchasePrompt.Utils.handlePriceChangedError)

local completePurchase = require(script.Parent.completePurchase)
local GetFFlagEnableCreatorStorePurchasingCutover = require(PurchasePrompt.Flags.GetFFlagEnableCreatorStorePurchasingCutover)
local logUnifiedPurchaseTelemetryCounter = require(PurchasePrompt.Utils.logUnifiedPurchaseTelemetryCounter)
local reportPurchasePromptNonCollectiblePurchase = require(PurchasePrompt.Telemetry.reportPurchasePromptNonCollectiblePurchase)
local UnifiedPurchaseTelemetry = require(PurchasePrompt.Events.UnifiedPurchaseTelemetry)

local SharedFlags = require(parent.SharedFlags)
local FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = SharedFlags.FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow

local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnablePurchasePayloadInExperienceShop = SharedFlags2.FFlagEnablePurchasePayloadInExperienceShop
local SharedFlags3 = require(parent.SharedFlags)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = SharedFlags3.FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagMockDevSubPurchaseInStudio = require(PurchasePrompt.Flags.FFlagMockDevSubPurchaseInStudio)

local SharedFlags4 = require(parent.SharedFlags)
local FFlagEnableMarketplacePurchaseDeepLinkAttribution = SharedFlags4.FFlagEnableMarketplacePurchaseDeepLinkAttribution

local SharedFlags5 = require(parent.SharedFlags)
local FFlagEnableNonCollectiblePurchaseCountersLua = SharedFlags5.FFlagEnableNonCollectiblePurchaseCountersLua

local SharedFlags6 = require(parent.SharedFlags)
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags6.FFlagLuaAppsEnablePromptVIPServerPurchase

local v = { Network, Analytics, ExternalSettings }

function isLuaPurchase(p)
	if p == nil then
		return false
	end

	return (p.kind == productTypeEnum.Product and p.universeId ~= nil or p.kind == productTypeEnum.Experience or p.kind == productTypeEnum.Look or FFlagEnableUnifiedPurchaseFlowForDevSubs and p.kind == productTypeEnum.DeveloperSubscription)
		and true
		or FFlagLuaAppsEnablePromptVIPServerPurchase and p.kind == productTypeEnum.VIPServer
end

local function purchaseItem()
	return Thunk.new(script.Name, v, function(object, p)
		local v2 = p[Network]
		local v3 = p[ExternalSettings]
		local v4 = p[Analytics]

		local state = object:getState()
		local purchaseFlow = state.purchaseFlow
		local requestType = state.promptRequest.requestType

		if state.cartPricing == nil or not state.cartPricing.isFetching then
			local platform = v3.getPlatform()

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
				local v5 = {}
				v5.avatarName = state.productInfo.name
				v5.avatarDescription = state.productInfo.description
				v5.priceFromToken = state.productInfo.price

				local v6 = { Enum.ExperienceAuthScope.CreatorAssetsCreate }

				ExperienceAuthService:ScopeCheckUIComplete(
					state.promptRequest.id,
					v6,
					Enum.ScopeCheckResult.ConsentAccepted,
					v5
				)

				v4.signalAvatarCreationPurchaseSubmit()

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
				local v5 = selectProductPrice(state2)
				local assetTypeId = state2.productInfo.assetTypeId
				local assetType = state2.productInfo.assetType
				local productId = state2.productInfo.productId
				local collectibleItemId2 = state2.productInfo.collectibleItemId
				local collectibleProductId2 = state2.productInfo.collectibleProductId

				local v6 = derivePurchaseOptionsFromCartPricingResponse(state2.cartPricing and state2.cartPricing.response)

				if FFlagEnableMarketplacePurchaseDeepLinkAttribution then
					local deepLinkId = state2.productPayload and state2.productPayload.deepLinkId

					if deepLinkId ~= nil and deepLinkId ~= "" then
						v6 = v6 or {}
						v6.DeepLinkId = deepLinkId
					end
				end

				local itemType = state2.productInfo.itemType

				v4.signalProductPurchaseConfirmed(productId, state2.requestType)
				local v7

				if collectibleItemId then
					if collectibleItemId == "" then
						v7 = false
					else
						v7 = infoType == Enum.InfoType.Bundle
					end
				else
					v7 = collectibleItemId
				end

				if isLuaPurchase(state2.productPayload) then
					if
						FFlagMockDevSubPurchaseInStudio
						and FFlagEnableUnifiedPurchaseFlowForDevSubs
						and state2.productPayload.kind == productTypeEnum.DeveloperSubscription
						and v3.isStudio()
					then
						object:dispatch(completePurchase())
					else
						object:dispatch(performLuaPurchase())
					end
				else
					if GetFFlagEnableCreatorStorePurchasingCutover() and isCreatorStoreAssetType(assetType) then
						return performCreatorStorePurchase(v2, productId, assetType):andThen(function(p2)
							object:dispatch(completePurchase())

							v4.signalPurchaseSuccess(id, infoType, v5, p2)

							return Promise.resolve()
						end):catch(function(p2)
							object:dispatch(ErrorOccurred(p2))
						end)
					end

					if v7 or collectibleItemInstanceId and collectibleItemInstanceId ~= "" then
						return performPurchaseV2(
							v2,
							infoType,
							productId,
							v5,
							guid,
							isRobloxPurchase,
							collectibleItemId,
							collectibleProductId,
							idempotencyKey,
							purchaseAuthToken,
							collectibleItemInstanceId,
							v6
						):andThen(function(p2)
							object:dispatch(completePurchase(p2))

							v4.signalPurchaseSuccess(id, infoType, v5, p2)

							return Promise.resolve()
						end):catch(function(p2)
							if isEconomicRestrictionResponse(p2) then
								object:dispatch(SetEconomicRestrictionError(
									parseEconomicRestrictionsFailureReason(p2),
									(parseEconomicRestrictionsExpirationTimeInMinutes(p2))
								))
								object:dispatch(ErrorOccurred(PurchaseError.EconomicRestriction))
							else
								if handlePriceChangedError(
									object,
									p2,
									state2.productPayload and state2.productPayload.kind
								) then
									return
								end

								if p2 == PurchaseError.TwoFactorNeeded then
									v4.signalTwoSVSettingsErrorShown(productId, infoType)

									if platform == Enum.Platform.Windows or platform == Enum.Platform.OSX then
										p2 = PurchaseError.TwoFactorNeededSettings
									end
								end

								object:dispatch(ErrorOccurred(p2))
							end
						end)
					end

					if
						FFlagEnableNonCollectiblePurchaseCountersLua
						and (collectibleItemId2 == nil or collectibleItemId2 == "")
					then
						reportPurchasePromptNonCollectiblePurchase(infoType, state2.productInfo)
					end

					local timedOptionDays

					if FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow then
						timedOptionDays = state2.productPayload and state2.productPayload.timedOptionDays
					end

					local v8

					if FFlagEnablePurchasePayloadInExperienceShop then
						v8 = mergeOfferIdsIntoPurchasePayload(
							state2.productPayload and state2.productPayload.purchasePayload,
							v6
						)
					end

					if not FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow then
						timedOptionDays = nil
					end

					if not FFlagEnablePurchasePayloadInExperienceShop then
						v8 = nil
					end

					return performPurchase(
						v2,
						infoType,
						productId,
						v5,
						guid,
						isRobloxPurchase,
						collectibleItemId2,
						collectibleProductId2,
						idempotencyKey,
						purchaseAuthToken,
						timedOptionDays,
						v8,
						v6
					):andThen(function(p2)
						object:dispatch(completePurchase(p2))

						if itemType ~= ItemType.Bundle then
							v4.signalPurchaseSuccess(id, infoType, v5, p2)
						end

						if equipIfPurchased and assetTypeId == 19 then
							return getToolAsset(v2, id):andThen(function(p3)
								if p3 then
									p3.Parent = Players.LocalPlayer.Backpack
								end
							end)
						end

						return Promise.resolve()
					end):catch(function(p2)
						if isEconomicRestrictionResponse(p2) then
							object:dispatch(SetEconomicRestrictionError(
								parseEconomicRestrictionsFailureReason(p2),
								(parseEconomicRestrictionsExpirationTimeInMinutes(p2))
							))
							object:dispatch(ErrorOccurred(PurchaseError.EconomicRestriction))
						else
							if handlePriceChangedError(object, p2, state2.productPayload and state2.productPayload.kind) then
								return
							end

							if p2 == PurchaseError.TwoFactorNeeded then
								v4.signalTwoSVSettingsErrorShown(productId, infoType)

								if platform == Enum.Platform.Windows or platform == Enum.Platform.OSX then
									p2 = PurchaseError.TwoFactorNeededSettings
								end
							end

							object:dispatch(ErrorOccurred(p2))
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
