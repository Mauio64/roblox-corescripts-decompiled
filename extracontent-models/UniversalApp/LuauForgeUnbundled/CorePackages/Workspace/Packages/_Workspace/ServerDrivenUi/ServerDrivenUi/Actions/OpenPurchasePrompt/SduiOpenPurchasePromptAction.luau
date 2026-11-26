local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiActionType = SduiCoreSystem.SduiActionType
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CentralOverlay").Actions.SetCentralOverlay
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CentralOverlay").Thunks.CloseCentralOverlay
local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/RobloxAppEnums").CentralOverlayType
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Promise")
local timeToInteractiveTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/TimeToInteractiveTracker").TimeToInteractiveTracker
local PurchasePromptLite = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/PurchasePromptLite")
local productPurchaseSurface = PurchasePromptLite.Enums.ProductPurchaseSurface
local productKind = PurchasePromptLite.Enums.ProductKind
local sduiReportGamePlayIntent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").sduiReportGamePlayIntent
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags")
local fFlagSduiDevStoreSeeAllSupport = SharedFlags.FFlagSduiDevStoreSeeAllSupport
local fFlagEnableHomeGameItemOwnershipUpdate = SharedFlags.FFlagEnableHomeGameItemOwnershipUpdate
local fFlagEnableSearchGameItemOwnershipUpdate = SharedFlags.FFlagEnableSearchGameItemOwnershipUpdate
local fFlagEnableEdpPreviewPurchaseSurface = SharedFlags.FFlagEnableEdpPreviewPurchaseSurface
local fFlagEnableLaunchAfterPurchase = SharedFlags.FFlagEnableLaunchAfterPurchase

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

	for k, item in priceDiscountDetails do
		table.insert(result, {
			Type = item.type,
			AmountInRobux = item.amountInRobux,
			Percent = item.percent
		})
	end

	return result
end

local function buildFetchProductInfo(data, p2)
	if data == nil then
		return nil
	end

	return function()
		return Promise.resolve({
			ProductId = data.productId,
			TargetId = data.targetId,
			Name = data.productName,
			Description = data.description,
			PriceInRobux = data.priceInRobux,
			IsForSale = data.isForSale == nil or data.isForSale,
			ProductType = data.productType or p2,
			ImageUrl = data.imageUrl,
			DisplayPrice = data.displayPrice,
			IconImageAssetId = data.iconImageAssetId,
			BasePriceInRobux = data.basePriceInRobux,
			PriceDiscountDetails = mapPriceDiscountDetails(data.priceDiscountDetails)
		})
	end
end

local function buildOnPurchaseSuccess(surface, kind, id, rootPlaceId)
	if not id then
		return nil
	end

	if
		kind == productKind.Gamepass
		and (surface == productPurchaseSurface.EDP or fFlagEnableHomeGameItemOwnershipUpdate and surface == productPurchaseSurface.HomePageGameItemShop or fFlagEnableSearchGameItemOwnershipUpdate and surface == productPurchaseSurface.SearchPageGameItemShop or fFlagEnableEdpPreviewPurchaseSurface and surface == productPurchaseSurface.EDPPreview)
	then
		return function()
			DataHydration.Game.getGamePassStore(false).updateGamePassInfo(id, {
				isOwned = true
			})
		end
	end

	if
		fFlagSduiDevStoreSeeAllSupport
		and kind == productKind.DeveloperSubscription
		and surface == productPurchaseSurface.EDP
	then
		return function()
			DataHydration.Game.getGameSubscriptionStore(false).updateGameSubscriptionInfo(id, {
				isSubscribed = true
			})
		end
	end

	if
		kind == productKind.Product
		and rootPlaceId
		and (fFlagSduiDevStoreSeeAllSupport and surface == productPurchaseSurface.EDP or fFlagEnableHomeGameItemOwnershipUpdate and surface == productPurchaseSurface.HomePageGameItemShop or fFlagEnableSearchGameItemOwnershipUpdate and surface == productPurchaseSurface.SearchPageGameItemShop or fFlagSduiDevStoreSeeAllSupport and fFlagEnableEdpPreviewPurchaseSurface and surface == productPurchaseSurface.EDPPreview)
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

local function buildOnPurchaseComplete(p2, p3, callback)
	if defineFastFlag and p2 == productPurchaseSurface.EDP and p3 then
		return function()
			ExperienceService:LaunchExperience({ placeId = tonumber(p3) })
			callback(closeCentralOverlay())
		end
	end

	return nil
end

local function buildOnLaunchAfterPurchase(p2, p3, p4)
	return function()
		local logger = p2.dependencies.logger

		if p4 == nil then
			logger.reportError(
				sduiErrorType.InvalidActionParams,
				{
					name = sduiActionType.OpenPurchasePrompt,
					message = "Missing rootPlaceId for launch-after-purchase play attribution"
				},
				p2.appPage
			)
			return
		end

		local analyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors("universeId", p3)

		if analyticsFieldInAncestors == nil or tostring(analyticsFieldInAncestors) == "" then
			logger.reportError(
				sduiErrorType.InvalidActionParams,
				{
					name = sduiActionType.OpenPurchasePrompt,
					message = "Missing universeId for launch-after-purchase play attribution"
				},
				p2.appPage
			)
		else
			sduiReportGamePlayIntent({
				sduiContext = p2,
				analyticsContext = p3,
				universeId = tostring(analyticsFieldInAncestors),
				placeId = p4,
				rootPlaceId = p4,
				actionType = "PlayAfterPurchase"
			})
		end
	end
end

local function buildOnFlowComplete(callback)
	return function()
		callback(closeCentralOverlay())
	end
end

local function normalizeProductPayload(productPayload, kind)
	if
		(kind == productKind.Gamepass or kind == productKind.Product)
		and typeof(productPayload.id) == "string"
	then
		local id = tonumber(productPayload.id)

		if id ~= nil then
			productPayload.id = id
		end
	end

	if kind == productKind.DeveloperSubscription then
		local v5 = productPayload.expectedPrice

		if typeof(v5) == "string" then
			v5 = tonumber(v5) or 0
			productPayload.expectedPrice = v5
		end

		if productPayload.isSubscriptionInRobux == nil then
			productPayload.isSubscriptionInRobux = typeof(v5) == "number" and v5 > 0
		end
	end
end

local v5 = {
	[productPurchaseSurface.HomePageGameItemShop] = "homePageGameItemShop",
	[productPurchaseSurface.SearchPageGameItemShop] = fFlagEnableSearchGameItemOwnershipUpdate and "searchPageGameItemShop" or nil,
	[productPurchaseSurface.EDPPreview] = fFlagEnableEdpPreviewPurchaseSurface and "experienceDetailPagePreview" or nil
}

local function buildPurchasePayload(p2)
	return HttpService:JSONEncode({
		surface = {
			scopeType = "lua",
			location = { locationType = p2 }
		}
	})
end

return function(p2, p3, p4)
	local logger = p4.dependencies.logger
	local appPage = p4.appPage
	local dispatch = p4.dependencies.dispatch

	local actionParams = p2 and p2.actionParams

	if actionParams == nil then
		logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenPurchasePrompt,
				message = "Missing action params"
			},
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
			sduiErrorType.InvalidActionParams,
			{
				name = sduiActionType.OpenPurchasePrompt,
				message = "Missing productPayload"
			},
			appPage
		)

		return
	end

	local kind = productPayload.kind

	local id = productPayload.id or productPayload.subscriptionId
	normalizeProductPayload(productPayload, kind)
	local surface = purchaseAnalyticsMetadata and purchaseAnalyticsMetadata.surface

	if defineFastFlag2 and surface ~= nil then
		local v6 = v5[surface]

		if v6 ~= nil then
			productPayload.purchasePayload = buildPurchasePayload(v6)
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
	dispatch(setCentralOverlay(centralOverlayType.UnifiedProductPurchaseModal, {
		productPayload = productPayload,
		purchaseCallbacks = {
			onPurchaseSuccess = buildOnPurchaseSuccess(surface, kind, id, rootPlaceId),
			fetchProductInfo = displayInfo ~= nil and function()
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
			end or nil,
			onFlowComplete = function()
				dispatch(closeCentralOverlay())
			end,
			onPurchaseComplete = defineFastFlag and surface == productPurchaseSurface.EDP and rootPlaceId and function()
				ExperienceService:LaunchExperience({ placeId = tonumber(rootPlaceId) })
				dispatch(closeCentralOverlay())
			end or nil,
			onLaunchAfterPurchase = fFlagEnableLaunchAfterPurchase and function()
				local logger2 = p4.dependencies.logger

				if rootPlaceId == nil then
					logger2.reportError(
						sduiErrorType.InvalidActionParams,
						{
							name = sduiActionType.OpenPurchasePrompt,
							message = "Missing rootPlaceId for launch-after-purchase play attribution"
						},
						p4.appPage
					)
					return
				end

				local analyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors("universeId", p3)

				if analyticsFieldInAncestors == nil or tostring(analyticsFieldInAncestors) == "" then
					logger2.reportError(
						sduiErrorType.InvalidActionParams,
						{
							name = sduiActionType.OpenPurchasePrompt,
							message = "Missing universeId for launch-after-purchase play attribution"
						},
						p4.appPage
					)
				else
					sduiReportGamePlayIntent({
						sduiContext = p4,
						analyticsContext = p3,
						universeId = tostring(analyticsFieldInAncestors),
						placeId = rootPlaceId,
						rootPlaceId = rootPlaceId,
						actionType = "PlayAfterPurchase"
					})
				end
			end or nil
		},
		purchaseAnalyticsMetadata = purchaseAnalyticsMetadata,
		purchaseOptions = purchaseOptions
	}))
end
