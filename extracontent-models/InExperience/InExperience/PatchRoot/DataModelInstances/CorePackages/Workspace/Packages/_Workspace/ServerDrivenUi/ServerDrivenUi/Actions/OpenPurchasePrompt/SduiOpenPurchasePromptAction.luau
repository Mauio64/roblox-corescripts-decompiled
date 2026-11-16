local parent = script:FindFirstAncestor("OpenPurchasePrompt"):FindFirstAncestor("ServerDrivenUi").Parent
local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiActionType = SduiCoreSystem.SduiActionType
local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local CentralOverlay2 = require(parent.CentralOverlay)
local CloseCentralOverlay = CentralOverlay2.Thunks.CloseCentralOverlay
local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local DataHydration = require(parent.DataHydration)
local Promise = require(parent.Promise)
local TimeToInteractiveTracker = require(parent.TimeToInteractiveTracker)
local timeToInteractiveTracker = TimeToInteractiveTracker.TimeToInteractiveTracker
local PurchasePromptLite = require(parent.PurchasePromptLite)
local ProductPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface
local ProductKind = PurchasePromptLite.Enums.ProductKind
local SduiSharedContent = require(parent.SduiSharedContent)
local sduiReportGamePlayIntent = SduiSharedContent.sduiReportGamePlayIntent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiDevStoreSeeAllSupport = SharedFlags.FFlagSduiDevStoreSeeAllSupport
local FFlagEnableHomeGameItemOwnershipUpdate = SharedFlags.FFlagEnableHomeGameItemOwnershipUpdate
local FFlagEnableSearchGameItemOwnershipUpdate = SharedFlags.FFlagEnableSearchGameItemOwnershipUpdate
local FFlagEnableEdpPreviewPurchaseSurface = SharedFlags.FFlagEnableEdpPreviewPurchaseSurface
local FFlagEnableLaunchAfterPurchase = SharedFlags.FFlagEnableLaunchAfterPurchase

local ExperienceService = game:GetService("ExperienceService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local defineFastFlag = game:DefineFastFlag("EnableJoinAfterBuyFromEDP", false)
local defineFastFlag2 = game:DefineFastFlag("EnablePurchasePayloadForSduiPurchase", false)

local function mapPriceDiscountDetails(priceDiscountDetails)
	if priceDiscountDetails == nil or #priceDiscountDetails == 0 then
		return nil
	end

	local result = {}

	for _, item in priceDiscountDetails do
		table.insert(result, {
			Type = item.type,
			AmountInRobux = item.amountInRobux,
			Percent = item.percent
		})
	end

	return result
end

local function buildFetchProductInfo(displayInfo, kind: string?) -- 1 equivalent call inferred from this helper
	if displayInfo == nil then
		return nil
	end

	return function()
		return Promise.resolve({
			ProductId = displayInfo.productId,
			TargetId = displayInfo.targetId,
			Name = displayInfo.productName,
			Description = displayInfo.description,
			PriceInRobux = displayInfo.priceInRobux,
			IsForSale = displayInfo.isForSale == nil or displayInfo.isForSale,
			ProductType = displayInfo.productType or kind,
			ImageUrl = displayInfo.imageUrl,
			DisplayPrice = displayInfo.displayPrice,
			IconImageAssetId = displayInfo.iconImageAssetId,
			BasePriceInRobux = displayInfo.basePriceInRobux,
			PriceDiscountDetails = mapPriceDiscountDetails(displayInfo.priceDiscountDetails)
		})
	end
end

local function buildOnPurchaseSuccess(surface: string?, kind: string?, id: string?, rootPlaceId: string?)
	if not id then
		return nil
	end

	if
		kind == ProductKind.Gamepass
		and (surface == ProductPurchaseSurface.EDP or FFlagEnableHomeGameItemOwnershipUpdate and surface == ProductPurchaseSurface.HomePageGameItemShop or FFlagEnableSearchGameItemOwnershipUpdate and surface == ProductPurchaseSurface.SearchPageGameItemShop or FFlagEnableEdpPreviewPurchaseSurface and surface == ProductPurchaseSurface.EDPPreview)
	then
		return function()
			DataHydration.Game.getGamePassStore(false).updateGamePassInfo(id, { isOwned = true })
		end
	end

	if
		FFlagSduiDevStoreSeeAllSupport
		and kind == ProductKind.DeveloperSubscription
		and surface == ProductPurchaseSurface.EDP
	then
		return function()
			DataHydration.Game.getGameSubscriptionStore(false).updateGameSubscriptionInfo(id, {
				isSubscribed = true
			})
		end
	end

	if
		kind == ProductKind.Product
		and rootPlaceId
		and (FFlagSduiDevStoreSeeAllSupport and surface == ProductPurchaseSurface.EDP or FFlagEnableHomeGameItemOwnershipUpdate and surface == ProductPurchaseSurface.HomePageGameItemShop or FFlagEnableSearchGameItemOwnershipUpdate and surface == ProductPurchaseSurface.SearchPageGameItemShop or FFlagSduiDevStoreSeeAllSupport and FFlagEnableEdpPreviewPurchaseSurface and surface == ProductPurchaseSurface.EDPPreview)
	then
		return function()
			local localPlayer = Players.LocalPlayer
			local userId = localPlayer and localPlayer.UserId

			if userId == nil then
				return
			end

			DataHydration.Game.getGameDeveloperProductStore(false).fetchStatuses(
				tostring(userId),
				(tostring(rootPlaceId))
			)
		end
	end

	return nil
end

local function buildOnPurchaseComplete(surface: string?, rootPlaceId: string?, dispatch) -- 1 equivalent call inferred from this helper
	if defineFastFlag and surface == ProductPurchaseSurface.EDP and rootPlaceId then
		return function()
			ExperienceService:LaunchExperience({ placeId = tonumber(rootPlaceId) })
			dispatch(CloseCentralOverlay())
		end
	end

	return nil
end

local function buildOnLaunchAfterPurchase(sduiContext, analyticsContext, rootPlaceId: string?) -- 1 equivalent call inferred from this helper
	return function()
		local logger = sduiContext.dependencies.logger

		if rootPlaceId == nil then
			logger.reportError(
				SduiErrorType.InvalidActionParams,
				{
					name = SduiActionType.OpenPurchasePrompt,
					message = "Missing rootPlaceId for launch-after-purchase play attribution"
				},
				sduiContext.appPage
			)
			return
		end

		local analyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors("universeId", analyticsContext)

		if analyticsFieldInAncestors == nil or tostring(analyticsFieldInAncestors) == "" then
			logger.reportError(
				SduiErrorType.InvalidActionParams,
				{
					name = SduiActionType.OpenPurchasePrompt,
					message = "Missing universeId for launch-after-purchase play attribution"
				},
				sduiContext.appPage
			)
		else
			sduiReportGamePlayIntent({
				sduiContext = sduiContext,
				analyticsContext = analyticsContext,
				universeId = tostring(analyticsFieldInAncestors),
				placeId = rootPlaceId,
				rootPlaceId = rootPlaceId,
				actionType = "PlayAfterPurchase"
			})
		end
	end
end

local function buildOnFlowComplete(dispatch) -- 1 equivalent call inferred from this helper
	return function()
		dispatch(CloseCentralOverlay())
	end
end

local function normalizeProductPayload(productPayload, kind: string?)
	if (kind == ProductKind.Gamepass or kind == ProductKind.Product) and typeof(productPayload.id) == "string" then
		local id = tonumber(productPayload.id)

		if id ~= nil then
			productPayload.id = id
		end
	end

	if kind == ProductKind.DeveloperSubscription then
		local expectedPrice = productPayload.expectedPrice

		if typeof(expectedPrice) == "string" then
			expectedPrice = tonumber(expectedPrice) or 0
			productPayload.expectedPrice = expectedPrice
		end

		if productPayload.isSubscriptionInRobux == nil then
			productPayload.isSubscriptionInRobux = typeof(expectedPrice) == "number" and expectedPrice > 0
		end
	end
end

local v = {
	[ProductPurchaseSurface.HomePageGameItemShop] = "homePageGameItemShop",
	[ProductPurchaseSurface.SearchPageGameItemShop] = FFlagEnableSearchGameItemOwnershipUpdate and "searchPageGameItemShop" or nil,
	[ProductPurchaseSurface.EDPPreview] = FFlagEnableEdpPreviewPurchaseSurface and "experienceDetailPagePreview" or nil
}

local function buildPurchasePayload(locationType: string)
	return HttpService:JSONEncode({
		surface = {
			scopeType = "lua",
			location = { locationType = locationType }
		}
	})
end

return function(p, analyticsContext, sduiContext)
	local logger = sduiContext.dependencies.logger
	local appPage = sduiContext.appPage
	local dispatch = sduiContext.dependencies.dispatch

	local actionParams = p and p.actionParams

	if actionParams == nil then
		logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenPurchasePrompt, message = "Missing action params" },
			appPage
		)

		return
	end

	local productPayload = actionParams.productPayload
	local displayInfo = actionParams.displayInfo
	local purchaseOptions = actionParams.purchaseOptions
	local purchaseAnalyticsMetadata = actionParams.purchaseAnalyticsMetadata
	local rootPlaceId = actionParams.rootPlaceId

	if productPayload == nil then
		logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = SduiActionType.OpenPurchasePrompt, message = "Missing productPayload" },
			appPage
		)

		return
	end

	local kind = productPayload.kind

	local id = productPayload.id or productPayload.subscriptionId
	normalizeProductPayload(productPayload, kind)
	local surface = purchaseAnalyticsMetadata and purchaseAnalyticsMetadata.surface

	if defineFastFlag2 and surface ~= nil then
		local locationType = v[surface]

		if locationType ~= nil then
			productPayload.purchasePayload = buildPurchasePayload(locationType)
		end
	end

	if purchaseOptions and purchaseOptions.enablePreloadedPurchaseUi ~= nil then
		purchaseOptions.enablePreloadedPurchaseUI = purchaseOptions.enablePreloadedPurchaseUi
		purchaseOptions.enablePreloadedPurchaseUi = nil
	end

	local ttiEventName = PurchasePromptLite.getTTIEventName(surface or "Unknown")
	timeToInteractiveTracker.trackStart(ttiEventName)
	timeToInteractiveTracker.updateMetadata(ttiEventName, {
		page = surface,
		category = "unified_purchase_modal"
	})

	dispatch(SetCentralOverlay(CentralOverlayType.UnifiedProductPurchaseModal, {
		productPayload = productPayload,
		purchaseCallbacks = {
			onPurchaseSuccess = buildOnPurchaseSuccess(surface, kind, id, rootPlaceId),
			fetchProductInfo = buildFetchProductInfo(displayInfo, kind), -- inferred equivalent call
			onFlowComplete = buildOnFlowComplete(dispatch), -- inferred equivalent call
			onPurchaseComplete = buildOnPurchaseComplete(surface, rootPlaceId, dispatch), -- inferred equivalent call
			onLaunchAfterPurchase = FFlagEnableLaunchAfterPurchase and buildOnLaunchAfterPurchase( -- inferred equivalent call
				sduiContext,
				analyticsContext,
				rootPlaceId
			) or nil
		},
		purchaseAnalyticsMetadata = purchaseAnalyticsMetadata,
		purchaseOptions = purchaseOptions
	}))
end
