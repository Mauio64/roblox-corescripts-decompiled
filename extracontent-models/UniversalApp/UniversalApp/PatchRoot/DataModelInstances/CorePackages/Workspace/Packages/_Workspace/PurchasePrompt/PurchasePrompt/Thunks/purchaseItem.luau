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
local t1 = {
	Network,
	Analytics,
	ExternalSettings
}

function isLuaPurchase(p1) -- line: 76
	-- upvalues: ProductTypeEnum (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy)
	if p1 == nil then
		return false
	end

	return p1.kind == ProductTypeEnum.Product and p1.universeId ~= nil or (p1.kind == ProductTypeEnum.Experience or (p1.kind == ProductTypeEnum.Look or FFlagEnableUnifiedPurchaseFlowForDevSubs and p1.kind == ProductTypeEnum.DeveloperSubscription))
end

local function purchaseItem() -- line: 89
	-- upvalues: Thunk (copy), t1 (copy), Network (copy), ExternalSettings (copy), Analytics (copy), FFlagPurchasePromptCartPricingEnabled (copy), logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy), StartPurchase (copy), Workspace (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), RequestType (copy), ExperienceAuthService (copy), completePurchase (copy), PurchaseFlow (copy), SetPromptState (copy), PromptState (copy), HttpService (copy), FFlagPurchasePromptPriceShouldUseProductInfoPrice (copy), selectProductPrice (copy), getPlayerPrice (copy), FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow (copy), derivePurchaseOptionsFromCartPricingResponse (copy), performLuaPurchase (copy), GetFFlagEnableCreatorStorePurchasingCutover (copy), isCreatorStoreAssetType (copy), performCreatorStorePurchase (copy), Promise (copy), ErrorOccurred (copy), performPurchaseV2 (copy), isEconomicRestrictionResponse (copy), parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), SetEconomicRestrictionError (copy), PurchaseError (copy), handlePriceChangedError (copy), FFlagEnablePurchasePayloadInExperienceShop (copy), performPurchase (copy), ItemType (copy), getToolAsset (copy), Players (copy)
	return Thunk.new(script.Name, t1, function(p2, p3) -- line: 90
		-- upvalues: Network (copy), ExternalSettings (copy), Analytics (copy), FFlagPurchasePromptCartPricingEnabled (copy), logUnifiedPurchaseTelemetryCounter (copy), UnifiedPurchaseTelemetry (copy), StartPurchase (copy), Workspace (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), RequestType (copy), ExperienceAuthService (copy), completePurchase (copy), PurchaseFlow (copy), SetPromptState (copy), PromptState (copy), HttpService (copy), FFlagPurchasePromptPriceShouldUseProductInfoPrice (copy), selectProductPrice (copy), getPlayerPrice (copy), FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow (copy), derivePurchaseOptionsFromCartPricingResponse (copy), performLuaPurchase (copy), GetFFlagEnableCreatorStorePurchasingCutover (copy), isCreatorStoreAssetType (copy), performCreatorStorePurchase (copy), Promise (copy), ErrorOccurred (copy), performPurchaseV2 (copy), isEconomicRestrictionResponse (copy), parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), SetEconomicRestrictionError (copy), PurchaseError (copy), handlePriceChangedError (copy), FFlagEnablePurchasePayloadInExperienceShop (copy), performPurchase (copy), ItemType (copy), getToolAsset (copy), Players (copy)
		local v51 = p3[Network]
		local v52 = p3[ExternalSettings]
		local v53 = p3[Analytics]
		local v54 = p2:getState()
		local purchaseFlow = v54.purchaseFlow
		local requestType = v54.promptRequest.requestType

		if FFlagPurchasePromptCartPricingEnabled and (v54.cartPricing ~= nil and v54.cartPricing.isFetching) then
			local purchaseAnalyticsMetadata = v54.purchaseAnalyticsMetadata

			logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedCartPricingBuyBlockedWhileFetchingCounter, purchaseAnalyticsMetadata and purchaseAnalyticsMetadata.surface, purchaseAnalyticsMetadata and purchaseAnalyticsMetadata.productType)

			return
		end

		local v58 = v52.getPlatform()

		p2:dispatch(StartPurchase(Workspace.DistributedGameTime))

		if FFlagEnableUnifiedProductPurchaseFlow and p2:getState().isUserEligibleForUnifiedPurchaseFlow then
			logUnifiedPurchaseTelemetryCounter(UnifiedPurchaseTelemetry.UnifiedProductPurchaseModalPurchaseAttemptedCounter, v54.purchaseAnalyticsMetadata.surface, v54.purchaseAnalyticsMetadata.productType)

			if v54.purchaseCallbacks and v54.purchaseCallbacks.onPurchaseAttempt then
				v54.purchaseCallbacks.onPurchaseAttempt()
			end
		end

		if requestType == RequestType.AvatarCreationFee then
			local t2 = {
				avatarName = v54.productInfo.name,
				avatarDescription = v54.productInfo.description,
				priceFromToken = v54.productInfo.price
			}
			local t3 = {
				[1] = Enum.ExperienceAuthScope.CreatorAssetsCreate
			}

			ExperienceAuthService:ScopeCheckUIComplete(v54.promptRequest.id, t3, Enum.ScopeCheckResult.ConsentAccepted, t2)
			v53.signalAvatarCreationPurchaseSubmit()
			p2:dispatch(completePurchase())

			return
		end

		if purchaseFlow == PurchaseFlow.RobuxUpsellV2 or purchaseFlow == PurchaseFlow.LargeRobuxUpsell then
			p2:dispatch(SetPromptState(PromptState.PurchaseInProgress))
		end

		local v61 = p2:getState()
		local guid = HttpService:GenerateGUID(false)
		local id = v61.promptRequest.id
		local infoType = v61.promptRequest.infoType
		local equipIfPurchased = v61.promptRequest.equipIfPurchased
		local isRobloxPurchase = v61.promptRequest.isRobloxPurchase
		local purchaseAuthToken = v61.promptRequest.purchaseAuthToken
		local idempotencyKey = v61.promptRequest.idempotencyKey
		local collectibleItemId = v61.promptRequest.collectibleItemId
		local collectibleItemInstanceId = v61.promptRequest.collectibleItemInstanceId
		local collectibleProductId = v61.promptRequest.collectibleProductId
		local u72

		if FFlagPurchasePromptPriceShouldUseProductInfoPrice then
			u72 = selectProductPrice(v61)
		else
			local expectedPrice = v61.promptRequest.expectedPrice
			local v74 = v61.accountInfo.membershipType == 4

			u72 = getPlayerPrice(v61.productInfo, v74)

			if collectibleItemInstanceId and collectibleItemInstanceId ~= "" or FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow and v61.productPayload and v61.productPayload.timedOptionDays ~= nil then
				u72 = expectedPrice
			end
		end

		local assetTypeId = v61.productInfo.assetTypeId
		local assetType = v61.productInfo.assetType
		local productId = v61.productInfo.productId
		local collectibleItemId2 = v61.productInfo.collectibleItemId
		local collectibleProductId2 = v61.productInfo.collectibleProductId
		local v80 = nil

		if FFlagPurchasePromptCartPricingEnabled then
			v80 = derivePurchaseOptionsFromCartPricingResponse(v61.cartPricing and v61.cartPricing.response)
		end

		local itemType = v61.productInfo.itemType

		v53.signalProductPurchaseConfirmed(productId, v61.requestType)

		local v82 = collectibleItemId and (collectibleItemId ~= "" and infoType == Enum.InfoType.Bundle)

		if FFlagEnableUnifiedProductPurchaseFlow and isLuaPurchase(v61.productPayload) then
			p2:dispatch(performLuaPurchase())

			return
		end

		if GetFFlagEnableCreatorStorePurchasingCutover() and isCreatorStoreAssetType(assetType) then
			return performCreatorStorePurchase(v51, productId, assetType):andThen(function(p4) -- line: 232
				-- upvalues: p2 (copy), completePurchase (copy), v53 (copy), id (copy), infoType (copy), u72 (ref), Promise (copy)
				p2:dispatch(completePurchase())
				v53.signalPurchaseSuccess(id, infoType, u72, p4)

				return Promise.resolve()
			end):catch(function(p5) -- line: 241
				-- upvalues: p2 (copy), ErrorOccurred (copy)
				p2:dispatch(ErrorOccurred(p5))
			end)
		end

		if v82 or collectibleItemInstanceId and collectibleItemInstanceId ~= "" then
			return performPurchaseV2(v51, infoType, productId, u72, guid, isRobloxPurchase, collectibleItemId, collectibleProductId, idempotencyKey, purchaseAuthToken, collectibleItemInstanceId, (if not FFlagPurchasePromptCartPricingEnabled then nil else v80)):andThen(function(p6) -- line: 259
				-- upvalues: FFlagEnableUnifiedProductPurchaseFlow (copy), p2 (copy), completePurchase (copy), v53 (copy), id (copy), infoType (copy), u72 (ref), Promise (copy)
				if FFlagEnableUnifiedProductPurchaseFlow then
					p2:dispatch(completePurchase(p6))
				else
					p2:dispatch(completePurchase())
				end

				v53.signalPurchaseSuccess(id, infoType, u72, p6)

				return Promise.resolve()
			end):catch(function(p7) -- line: 274
				-- upvalues: isEconomicRestrictionResponse (copy), parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), p2 (copy), SetEconomicRestrictionError (copy), ErrorOccurred (copy), PurchaseError (copy), handlePriceChangedError (copy), v61 (copy), v53 (copy), productId (copy), infoType (copy), v58 (copy)
				if isEconomicRestrictionResponse(p7) then
					local v89 = parseEconomicRestrictionsFailureReason(p7)
					local v90 = parseEconomicRestrictionsExpirationTimeInMinutes(p7)

					p2:dispatch(SetEconomicRestrictionError(v89, v90))
					p2:dispatch(ErrorOccurred(PurchaseError.EconomicRestriction))

					return
				end

				if handlePriceChangedError(p2, p7, v61.productPayload and v61.productPayload.kind) then
					return
				end

				if p7 == PurchaseError.TwoFactorNeeded then
					v53.signalTwoSVSettingsErrorShown(productId, infoType)

					if v58 == Enum.Platform.Windows or v58 == Enum.Platform.OSX then
						p7 = PurchaseError.TwoFactorNeededSettings
					end
				end

				p2:dispatch(ErrorOccurred(p7))
			end)
		end

		local v83 = nil

		if FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow then
			v83 = v61.productPayload and v61.productPayload.timedOptionDays
		end

		local v84 = nil

		if FFlagEnablePurchasePayloadInExperienceShop then
			v84 = v61.productPayload and v61.productPayload.purchasePayload
		end

		return performPurchase(v51, infoType, productId, u72, guid, isRobloxPurchase, collectibleItemId2, collectibleProductId2, idempotencyKey, purchaseAuthToken, (if not FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow then nil else v83), (if not FFlagEnablePurchasePayloadInExperienceShop then nil else v84), (if not FFlagPurchasePromptCartPricingEnabled then nil else v80)):andThen(function(p8) -- line: 323
			-- upvalues: FFlagEnableUnifiedProductPurchaseFlow (copy), p2 (copy), completePurchase (copy), itemType (copy), ItemType (copy), v53 (copy), id (copy), infoType (copy), u72 (ref), equipIfPurchased (copy), assetTypeId (copy), getToolAsset (copy), v51 (copy), Players (copy), Promise (copy)
			if FFlagEnableUnifiedProductPurchaseFlow then
				p2:dispatch(completePurchase(p8))
			else
				p2:dispatch(completePurchase())
			end

			if itemType ~= ItemType.Bundle then
				v53.signalPurchaseSuccess(id, infoType, u72, p8)
			end

			if equipIfPurchased and assetTypeId == 19 then
				return getToolAsset(v51, id):andThen(function(p9) -- line: 341
					-- upvalues: Players (copy)
					if p9 then
						p9.Parent = Players.LocalPlayer.Backpack
					end
				end)
			end

			return Promise.resolve()
		end):catch(function(p10) -- line: 350
			-- upvalues: isEconomicRestrictionResponse (copy), parseEconomicRestrictionsFailureReason (copy), parseEconomicRestrictionsExpirationTimeInMinutes (copy), p2 (copy), SetEconomicRestrictionError (copy), ErrorOccurred (copy), PurchaseError (copy), handlePriceChangedError (copy), v61 (copy), v53 (copy), productId (copy), infoType (copy), v58 (copy)
			if isEconomicRestrictionResponse(p10) then
				local v93 = parseEconomicRestrictionsFailureReason(p10)
				local v94 = parseEconomicRestrictionsExpirationTimeInMinutes(p10)

				p2:dispatch(SetEconomicRestrictionError(v93, v94))
				p2:dispatch(ErrorOccurred(PurchaseError.EconomicRestriction))

				return
			end

			if handlePriceChangedError(p2, p10, v61.productPayload and v61.productPayload.kind) then
				return
			end

			if p10 == PurchaseError.TwoFactorNeeded then
				v53.signalTwoSVSettingsErrorShown(productId, infoType)

				if v58 == Enum.Platform.Windows or v58 == Enum.Platform.OSX then
					p10 = PurchaseError.TwoFactorNeededSettings
				end
			end

			p2:dispatch(ErrorOccurred(p10))
		end)
	end)
end

return purchaseItem
