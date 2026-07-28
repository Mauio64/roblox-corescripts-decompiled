local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ExperienceAuthService = game:GetService("ExperienceAuthService")
local PurchasePromptParent = PurchasePrompt.Parent
local IAPExperience = require(PurchasePromptParent.IAPExperience)
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
local getPlayerPrice = require(PurchasePrompt.Utils.getPlayerPrice)
local isCreatorStoreAssetType = require(PurchasePrompt.Utils.isCreatorStoreAssetType)
local Thunk = require(PurchasePrompt.Thunk)
local Promise = require(PurchasePrompt.Promise)

require(PurchasePrompt.types)

local ProductTypeEnum = require(PurchasePrompt.types).ProductTypeEnum
local selectProductPrice = require(PurchasePrompt.Selectors.selectProductPrice)
local derivePurchaseOptionsFromCartPricingResponse = require(PurchasePrompt.Utils.derivePurchaseOptionsFromCartPricingResponse)
local performLuaPurchase = require(PurchasePrompt.Thunks.performLuaPurchase)
local handlePriceChangedError = require(PurchasePrompt.Utils.handlePriceChangedError)
local completePurchase = require(script.Parent.completePurchase)
local FFlagEnableUnifiedProductPurchaseFlow = require(PurchasePromptParent.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local GetFFlagEnableCreatorStorePurchasingCutover = require(PurchasePrompt.Flags.GetFFlagEnableCreatorStorePurchasingCutover)
local logUnifiedPurchaseTelemetryCounter = require(PurchasePrompt.Utils.logUnifiedPurchaseTelemetryCounter)
local UnifiedPurchaseTelemetry = require(PurchasePrompt.Events.UnifiedPurchaseTelemetry)
local FFlagPurchasePromptPriceShouldUseProductInfoPrice = require(PurchasePrompt.Flags.FFlagPurchasePromptPriceShouldUseProductInfoPrice)
local FFlagPurchasePromptCartPricingEnabled = require(PurchasePrompt.Flags.FFlagPurchasePromptCartPricingEnabled)
local FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = require(PurchasePromptParent.SharedFlags).FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow
local FFlagEnablePurchasePayloadInExperienceShop = require(PurchasePromptParent.SharedFlags).FFlagEnablePurchasePayloadInExperienceShop
local FFlagEnableUnifiedPurchaseFlowForDevSubs = require(PurchasePromptParent.SharedFlags).FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagMockDevSubPurchaseInStudio = require(PurchasePrompt.Flags.FFlagMockDevSubPurchaseInStudio)
local t1 = {
	Network,
	Analytics,
	ExternalSettings
}

function isLuaPurchase(p1) -- line: 77
	-- upvalues: ProductTypeEnum (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy)
	if p1 == nil then
		return false
	end

	return p1.kind == ProductTypeEnum.Product and p1.universeId ~= nil or (p1.kind == ProductTypeEnum.Experience or (p1.kind == ProductTypeEnum.Look or FFlagEnableUnifiedPurchaseFlowForDevSubs and p1.kind == ProductTypeEnum.DeveloperSubscription))
end

local function purchaseItem() -- line: 90
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), ExternalSettings (copy), Analytics (copy), FFlagPurchasePromptCartPricingEnabled (copy), logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy), StartPurchase (copy), Workspace (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), RequestType (copy), ExperienceAuthService (copy), completePurchase (copy), PurchaseFlow (copy), SetPromptState (copy), PromptState (copy), HttpService (copy), FFlagPurchasePromptPriceShouldUseProductInfoPrice (copy), selectProductPrice (copy), getPlayerPrice (copy), FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow (copy), derivePurchaseOptionsFromCartPricingResponse (copy), FFlagMockDevSubPurchaseInStudio (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), ProductTypeEnum (copy), performLuaPurchase (copy), GetFFlagEnableCreatorStorePurchasingCutover (copy), isCreatorStoreAssetType (copy), performCreatorStorePurchase (copy), Promise (copy), ErrorOccurred (copy), performPurchaseV2 (copy), isEconomicRestrictionResponse (copy), parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), SetEconomicRestrictionError (copy), PurchaseError (copy), handlePriceChangedError (copy), FFlagEnablePurchasePayloadInExperienceShop (copy), performPurchase (copy), ItemType (copy), getToolAsset (copy), Players (copy)
	return Thunk.new(script.Name, t1, function(p2, p3) -- line: 91
		-- upvalues: Network (copy), ExternalSettings (copy), Analytics (copy), FFlagPurchasePromptCartPricingEnabled (copy), logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy), StartPurchase (copy), Workspace (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), RequestType (copy), ExperienceAuthService (copy), completePurchase (copy), PurchaseFlow (copy), SetPromptState (copy), PromptState (copy), HttpService (copy), FFlagPurchasePromptPriceShouldUseProductInfoPrice (copy), selectProductPrice (copy), getPlayerPrice (copy), FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow (copy), derivePurchaseOptionsFromCartPricingResponse (copy), FFlagMockDevSubPurchaseInStudio (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), ProductTypeEnum (copy), performLuaPurchase (copy), GetFFlagEnableCreatorStorePurchasingCutover (copy), isCreatorStoreAssetType (copy), performCreatorStorePurchase (copy), Promise (copy), ErrorOccurred (copy), performPurchaseV2 (copy), isEconomicRestrictionResponse (copy), parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), SetEconomicRestrictionError (copy), PurchaseError (copy), handlePriceChangedError (copy), FFlagEnablePurchasePayloadInExperienceShop (copy), performPurchase (copy), ItemType (copy), getToolAsset (copy), Players (copy)
		local v52 = p3[Network]
		local v53 = p3[ExternalSettings]
		local v54 = p3[Analytics]
		local v55 = p2:getState()
		local purchaseFlow = v55.purchaseFlow
		local requestType = v55.promptRequest.requestType

		if FFlagPurchasePromptCartPricingEnabled and (v55.cartPricing ~= nil and v55.cartPricing.isFetching) then
			local purchaseAnalyticsMetadata = v55.purchaseAnalyticsMetadata

			logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedCartPricingBuyBlockedWhileFetchingCounter, purchaseAnalyticsMetadata and purchaseAnalyticsMetadata.surface, purchaseAnalyticsMetadata and purchaseAnalyticsMetadata.productType)

			return
		end

		local v59 = v53.getPlatform()

		p2:dispatch(StartPurchase(Workspace.DistributedGameTime))

		if FFlagEnableUnifiedProductPurchaseFlow and p2:getState().isUserEligibleForUnifiedPurchaseFlow then
			logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedProductPurchaseModalPurchaseAttemptedCounter, v55.purchaseAnalyticsMetadata.surface, v55.purchaseAnalyticsMetadata.productType)

			if v55.purchaseCallbacks and v55.purchaseCallbacks.onPurchaseAttempt then
				v55.purchaseCallbacks.onPurchaseAttempt()
			end
		end

		if requestType == RequestType.AvatarCreationFee then
			local t2 = {
				avatarName = v55.productInfo.name,
				avatarDescription = v55.productInfo.description,
				priceFromToken = v55.productInfo.price
			}
			local t3 = {
				[1] = Enum.ExperienceAuthScope.CreatorAssetsCreate
			}

			ExperienceAuthService:ScopeCheckUIComplete(v55.promptRequest.id, t3, Enum.ScopeCheckResult.ConsentAccepted, t2)
			v54.signalAvatarCreationPurchaseSubmit()
			p2:dispatch(completePurchase())

			return
		end

		if purchaseFlow == PurchaseFlow.RobuxUpsellV2 or purchaseFlow == PurchaseFlow.LargeRobuxUpsell then
			p2:dispatch(SetPromptState(PromptState.PurchaseInProgress))
		end

		local v62 = p2:getState()
		local guid = HttpService:GenerateGUID(false)
		local id = v62.promptRequest.id
		local infoType = v62.promptRequest.infoType
		local equipIfPurchased = v62.promptRequest.equipIfPurchased
		local isRobloxPurchase = v62.promptRequest.isRobloxPurchase
		local purchaseAuthToken = v62.promptRequest.purchaseAuthToken
		local idempotencyKey = v62.promptRequest.idempotencyKey
		local collectibleItemId = v62.promptRequest.collectibleItemId
		local collectibleItemInstanceId = v62.promptRequest.collectibleItemInstanceId
		local collectibleProductId = v62.promptRequest.collectibleProductId
		local u73

		if FFlagPurchasePromptPriceShouldUseProductInfoPrice then
			u73 = selectProductPrice(v62)
		else
			local expectedPrice = v62.promptRequest.expectedPrice
			local v75 = v62.accountInfo.membershipType == 4

			u73 = getPlayerPrice(v62.productInfo, v75)

			if collectibleItemInstanceId and collectibleItemInstanceId ~= "" or FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow and v62.productPayload and v62.productPayload.timedOptionDays ~= nil then
				u73 = expectedPrice
			end
		end

		local assetTypeId = v62.productInfo.assetTypeId
		local assetType = v62.productInfo.assetType
		local productId = v62.productInfo.productId
		local collectibleItemId2 = v62.productInfo.collectibleItemId
		local collectibleProductId2 = v62.productInfo.collectibleProductId
		local v81 = nil

		if FFlagPurchasePromptCartPricingEnabled then
			v81 = derivePurchaseOptionsFromCartPricingResponse(v62.cartPricing and v62.cartPricing.response)
		end

		local itemType = v62.productInfo.itemType

		v54.signalProductPurchaseConfirmed(productId, v62.requestType)

		local v83 = collectibleItemId and (collectibleItemId ~= "" and infoType == Enum.InfoType.Bundle)

		if FFlagEnableUnifiedProductPurchaseFlow and isLuaPurchase(v62.productPayload) then
			if FFlagMockDevSubPurchaseInStudio and FFlagEnableUnifiedPurchaseFlowForDevSubs and v62.productPayload.kind == ProductTypeEnum.DeveloperSubscription and v53.isStudio() then
				p2:dispatch(completePurchase())

				return
			end

			p2:dispatch(performLuaPurchase())

			return
		end

		if GetFFlagEnableCreatorStorePurchasingCutover() and isCreatorStoreAssetType(assetType) then
			return performCreatorStorePurchase(v52, productId, assetType):andThen(function(p4) -- line: 243
				-- upvalues: p2 (copy), completePurchase (copy), v54 (copy), id (copy), infoType (copy), u73 (ref), Promise (copy)
				p2:dispatch(completePurchase())
				v54.signalPurchaseSuccess(id, infoType, u73, p4)

				return Promise.resolve()
			end):catch(function(p5) -- line: 252
				-- upvalues: p2 (copy), ErrorOccurred (copy)
				p2:dispatch(ErrorOccurred(p5))
			end)
		end

		if v83 or collectibleItemInstanceId and collectibleItemInstanceId ~= "" then
			return performPurchaseV2(v52, infoType, productId, u73, guid, isRobloxPurchase, collectibleItemId, collectibleProductId, idempotencyKey, purchaseAuthToken, collectibleItemInstanceId, (if not FFlagPurchasePromptCartPricingEnabled then nil else v81)):andThen(function(p6) -- line: 270
				-- upvalues: FFlagEnableUnifiedProductPurchaseFlow (copy), p2 (copy), completePurchase (copy), v54 (copy), id (copy), infoType (copy), u73 (ref), Promise (copy)
				if FFlagEnableUnifiedProductPurchaseFlow then
					p2:dispatch(completePurchase(p6))
				else
					p2:dispatch(completePurchase())
				end

				v54.signalPurchaseSuccess(id, infoType, u73, p6)

				return Promise.resolve()
			end):catch(function(p7) -- line: 285
				-- upvalues: isEconomicRestrictionResponse (copy), parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), p2 (copy), SetEconomicRestrictionError (copy), ErrorOccurred (copy), PurchaseError (copy), handlePriceChangedError (copy), v62 (copy), v54 (copy), productId (copy), infoType (copy), v59 (copy)
				if isEconomicRestrictionResponse(p7) then
					local v90 = parseEconomicRestrictionsFailureReason(p7)
					local v91 = parseEconomicRestrictionsExpirationTimeInMinutes(p7)

					p2:dispatch(SetEconomicRestrictionError(v90, v91))
					p2:dispatch(ErrorOccurred(PurchaseError.EconomicRestriction))

					return
				end

				if handlePriceChangedError(p2, p7, v62.productPayload and v62.productPayload.kind) then
					return
				end

				if p7 == PurchaseError.TwoFactorNeeded then
					v54.signalTwoSVSettingsErrorShown(productId, infoType)

					if v59 == Enum.Platform.Windows or v59 == Enum.Platform.OSX then
						p7 = PurchaseError.TwoFactorNeededSettings
					end
				end

				p2:dispatch(ErrorOccurred(p7))
			end)
		end

		local v84 = nil

		if FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow then
			v84 = v62.productPayload and v62.productPayload.timedOptionDays
		end

		local v85 = nil

		if FFlagEnablePurchasePayloadInExperienceShop then
			v85 = v62.productPayload and v62.productPayload.purchasePayload
		end

		return performPurchase(v52, infoType, productId, u73, guid, isRobloxPurchase, collectibleItemId2, collectibleProductId2, idempotencyKey, purchaseAuthToken, (if not FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow then nil else v84), (if not FFlagEnablePurchasePayloadInExperienceShop then nil else v85), (if not FFlagPurchasePromptCartPricingEnabled then nil else v81)):andThen(function(p8) -- line: 334
			-- upvalues: FFlagEnableUnifiedProductPurchaseFlow (copy), p2 (copy), completePurchase (copy), itemType (copy), ItemType (copy), v54 (copy), id (copy), infoType (copy), u73 (ref), equipIfPurchased (copy), assetTypeId (copy), getToolAsset (copy), v52 (copy), Players (copy), Promise (copy)
			if FFlagEnableUnifiedProductPurchaseFlow then
				p2:dispatch(completePurchase(p8))
			else
				p2:dispatch(completePurchase())
			end

			if itemType ~= ItemType.Bundle then
				v54.signalPurchaseSuccess(id, infoType, u73, p8)
			end

			if equipIfPurchased and assetTypeId == 19 then
				return getToolAsset(v52, id):andThen(function(p9) -- line: 352
					-- upvalues: Players (copy)
					if p9 then
						p9.Parent = Players.LocalPlayer.Backpack
					end
				end)
			end

			return Promise.resolve()
		end):catch(function(p10) -- line: 361
			-- upvalues: isEconomicRestrictionResponse (copy), parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), p2 (copy), SetEconomicRestrictionError (copy), ErrorOccurred (copy), PurchaseError (copy), handlePriceChangedError (copy), v62 (copy), v54 (copy), productId (copy), infoType (copy), v59 (copy)
			if isEconomicRestrictionResponse(p10) then
				local v94 = parseEconomicRestrictionsFailureReason(p10)
				local v95 = parseEconomicRestrictionsExpirationTimeInMinutes(p10)

				p2:dispatch(SetEconomicRestrictionError(v94, v95))
				p2:dispatch(ErrorOccurred(PurchaseError.EconomicRestriction))

				return
			end

			if handlePriceChangedError(p2, p10, v62.productPayload and v62.productPayload.kind) then
				return
			end

			if p10 == PurchaseError.TwoFactorNeeded then
				v54.signalTwoSVSettingsErrorShown(productId, infoType)

				if v59 == Enum.Platform.Windows or v59 == Enum.Platform.OSX then
					p10 = PurchaseError.TwoFactorNeededSettings
				end
			end

			p2:dispatch(ErrorOccurred(p10))
		end)
	end)
end

return purchaseItem
