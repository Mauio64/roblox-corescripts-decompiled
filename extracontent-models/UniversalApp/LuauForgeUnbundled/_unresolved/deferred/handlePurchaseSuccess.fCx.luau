local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local module = require("@luauforge/bundled/dzP")
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local module7 = require("@luauforge/bundled/dKU")

local module8 = require("@luauforge/bundled/dPU")
local module9 = require("@luauforge/bundled/dPN")
local widgetConstants = AvatarExperienceCatalog.WidgetConstants

local module10 = require("@luauforge/bundled/fCy")
local module11 = require("@luauforge/deferred/fCA")
local module12 = require("@luauforge/bundled/dVl")
local itemData = AvatarExperienceCommon.State.Selectors.ItemData
local module13 = require("@luauforge/bundled/dzE")

local module14 = require("@luauforge/bundled/dQl")
local module15 = require("@luauforge/bundled/dQz")
local module16 = require("@luauforge/bundled/fCE")

local module17 = require("@luauforge/bundled/fCp")
local module18 = require("@luauforge/deferred/fCG")

local module19 = require("@luauforge/bundled/fCr")

local module20 = require("@luauforge/bundled/fCt")
local module21 = require("@luauforge/bundled/fCd")
local module22 = require("@luauforge/bundled/fCH")
local applyProfileConfiguration = module7.Actions.ApplyProfileConfiguration
local module23 = require("@luauforge/bundled/dFm")
local module24 = require("@luauforge/deferred/fCL")

local selectSearchKeyword = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Selectors.selectSearchKeyword
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey

local avatarLastEquippedStateStore = AvatarExperienceCommon.Stores.AvatarLastEquippedStateStore.avatarLastEquippedStateStore
local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogEnums

local sendUnifiedEventForDeferredAction = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendUnifiedEventForDeferredAction

local avatarScreenProperties = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.AvatarScreenProperties
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError
local normalizeDiscoveryPurchaseEntity = AvatarExperienceAnalytics.normalizeDiscoveryPurchaseEntity
local cartIdService = AvatarExperienceAnalytics.Lib.CartIdService
local mapAnalyticsMetadataFields = AvatarExperienceAnalytics.Utils.mapAnalyticsMetadataFields
local getWidgetAttributionFields = AvatarExperienceAnalytics.Utils.getWidgetAttributionFields
local unifiedSelectionListStore = AvatarExperienceAnalytics.Store.UnifiedSelectionListStore

local fFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup = AvatarExperienceFlags.FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup
local fFlagAXFixPurchaseSurfaceLogging = SharedFlags.FFlagAXFixPurchaseSurfaceLogging
local fFlagAXFixItemDetailsPurchaseAttribution = AvatarExperienceFlags.FFlagAXFixItemDetailsPurchaseAttribution
local fFlagAXDiscoveryItemPurchaseAttribution = SharedFlags.FFlagAXDiscoveryItemPurchaseAttribution

local mapMarketplaceSurfaceToUnifiedLoggingSurface = AvatarExperienceAnalytics.Utils.mapMarketplaceSurfaceToUnifiedLoggingSurface
local fFlagAXUnifiedPurchaseExtendRentalsFix = AvatarExperienceFlags.FFlagAXUnifiedPurchaseExtendRentalsFix
local fFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads
local fFlagAXBackgroundsCustomizeHydration = AvatarExperienceFlags.FFlagAXBackgroundsCustomizeHydration

local fFlagAXHideUnifiedPurchaseFlowSuccessToastMarketplace = AvatarExperienceFlags.FFlagAXHideUnifiedPurchaseFlowSuccessToastMarketplace
local fFlagSkipCompletionModalForMarketplace = SharedFlags.FFlagSkipCompletionModalForMarketplace

local function updateRobux(p2, object)
	local localUserId = object:getState().LocalUserId
	module.isNonEmptyString(localUserId, "Thunk.PurchaseProduct.updateRobux.localUserId")

	if typeof(localUserId) == "string" and localUserId ~= "" then
		object:dispatch(module10(p2, localUserId, true))
	end
end

local v5 = {
	toastMessage = "Feature.Catalog.Label.Purchased",
	isLocalized = false,
	toastType = module13.SuccessConfirmation
}

local function handlePurchaseSuccess(p2, p3, p4, p5, p6, p7, data, p8, p9, p10, p11, p12, p13, p14, p15)
	return function(object)
		local v6 = itemData(object:getState().AvatarExperience.Common, p5, p6)
		local isResellable = module12.IsResellable(v6)
		local v7 = p2

		if type(v7) ~= "table" then
			return
		end

		if isResellable then
			if p7 then
				object:dispatch(module19(p4, p7, nil, module8.MaxResellersPerPage))

				object:dispatch(module20(p4, p7, object:getState().LocalUserId))
			else
				object:dispatch(module17(p4, p5, nil, module8.MaxResellersPerPage, true))

				object:dispatch(module18(p4, p5, object:getState().LocalUserId))
			end
		end

		if not v7.purchased then
			object:dispatch(module11(v7))
			return Promise.reject(v7)
		end

		if p6 == module9.ItemType.Asset then
			object:dispatch(module14(p5, true))

			if fFlagAXUnifiedPurchaseExtendRentalsFix then
				object:dispatch(module21(p4, data, p5, p6, true))
			end
		else
			object:dispatch(module15(p5, true))
		end

		local v8 = p4
		local localUserId = object:getState().LocalUserId
		module.isNonEmptyString(localUserId, "Thunk.PurchaseProduct.updateRobux.localUserId")

		if typeof(localUserId) == "string" and localUserId ~= "" then
			object:dispatch(module10(v8, localUserId, true))
		end

		local success, result = pcall(function()
			local v9

			if p3[module9.WearAfterPurchasePostPurchaseActionKey] then
				v9 = p3[module9.WearAfterPurchasePostPurchaseActionKey]
			else
				v9 = false
			end

			local v10

			if p10 and p10.current and p10.opaque then
				if fFlagAXFixItemDetailsPurchaseAttribution then
					v10 = avatarScreenProperties[p10.current.name]

					if not (v10 and v10.analyticsData) then
						v10 = avatarScreenProperties[p10.opaque.name]
					end
				else
					v10 = avatarScreenProperties[p10.opaque.name]
				end
			end

			local v11 = nil

			if fFlagAXMISEnableMultiShoppingUnifiedEvents then
				if p6 == "Asset" then
					v11 = unifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
				elseif p6 == "Bundle" then
					v11 = unifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
				end
			end

			local v12

			if fFlagAXDiscoveryItemPurchaseAttribution and p15 then
				v12 = mapMarketplaceSurfaceToUnifiedLoggingSurface(p15.getParam(module9.NavigationParams.fromSurface))
			end

			local v13 = p12 or { widgetType = nil }

			local join = Cryo.Dictionary.join
			local analyticsMetadata = object:getState().AvatarExperience.AnalyticsMetadata
			local v14 = {
				action = unifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_SUCCESS,
				cartId = 0,
				keyword = 0,
				itemId = 0,
				itemType = 0,
				surface = 0,
				widgetItemWearAfterPurchase = 0,
				organicItemWearAfterPurchase = 0
			}

			local v15 = if fFlagAXMISEnableMultiShoppingUnifiedEvents then cartIdService.getCartId() else nil
			v14.cartId = v15

			v14.keyword = selectSearchKeyword(object:getState())
			v14.itemId = if fFlagAXMISEnableMultiShoppingUnifiedEvents then p5 else nil

			if not fFlagAXMISEnableMultiShoppingUnifiedEvents then
				v11 = nil
			end

			v14.itemType = v11

			if not (fFlagAXDiscoveryItemPurchaseAttribution and v12) then
				v12 = if v10 and v10.analyticsData then v10.analyticsData.unifiedLoggingSurface else nil
			end

			v14.surface = v12

			local v17 = if v13.widgetType then v9 else nil
			v14.widgetItemWearAfterPurchase = v17

			if v13.widgetType then
				v9 = nil
			end

			v14.organicItemWearAfterPurchase = v9
			local v18 = join(analyticsMetadata, v14)

			if fFlagAXUnifiedEventStrictPayloads then
				v18 = mapAnalyticsMetadataFields(v18)
			end

			local v19 = if fFlagAXUnifiedEventStrictPayloads then getWidgetAttributionFields(p12) else nil

			if fFlagAXDiscoveryItemPurchaseAttribution then
				sendUnifiedEventForDeferredAction(normalizeDiscoveryPurchaseEntity(v18), v19)
			else
				sendUnifiedEventForDeferredAction(v18, v19)
			end
		end)

		if not success then
			mutedError(result)
		end

		if fFlagAXMISEnableMultiShoppingUnifiedEvents then
			cartIdService.refreshCartId()
			unifiedSelectionListStore.clearSelectionList()
		end

		local tryOnItems = object:getState().AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

		if p6 == module9.ItemType.Asset then
			data.purchaseAsset(
				p5,
				p14,
				p13,
				p8,
				module24.checkTryOnHasAdjustments(tryOnItems, (tostring(p5))),
				p9
			)
		elseif p6 == module9.ItemType.Bundle then
			data.purchaseBundle(p5, p14, p13, p8, p9)
		end

		if p12 then
			local joined = Cryo.Dictionary.join(p12, { totalRobux = p13 })
			data.widgetInteractionV2(joined, widgetConstants.ActionType.PURCHASE_SUCCESS)
		end

		local requestId = object:getState().AvatarExperience.Common.Widgets.WidgetInfo.RequestId

		local state = object:getState()

		local v9 = selectSearchKeyword(state)
		local categoryAndSubcategory, v10 = module12.getCategoryAndSubcategory(state)

		local avatarShopBuyItem = data.avatarShopBuyItem

		local analyticsMetadata = object:getState().AvatarExperience.AnalyticsMetadata

		local v15 = if fFlagAXFixPurchaseSurfaceLogging and p15 then p15.getParam(module9.NavigationParams.fromSurface) else nil
		avatarShopBuyItem(
			p5,
			p6,
			p13,
			p11,
			requestId,
			v9,
			categoryAndSubcategory,
			v10,
			analyticsMetadata,
			v15
		)

		if
			not fFlagAXHideUnifiedPurchaseFlowSuccessToastMarketplace
			or fFlagSkipCompletionModalForMarketplace
		then
			object:dispatch(module23(v5))
		end

		object:dispatch(module16(p15))

		if p3[module9.WearAfterPurchasePostPurchaseActionKey] then
			if
				fFlagAXBackgroundsCustomizeHydration
				and p6 == module9.ItemType.Asset
				and p14 == module9.AssetTypeIdStrings.AvatarBackground
			then
				object:dispatch(applyProfileConfiguration({
					BackgroundAssetId = tonumber(p5)
				}))
			elseif p6 == module9.ItemType.Asset and p14 ~= module9.AssetTypeIdStrings.EmoteAnimation then
				if fFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup then
					avatarLastEquippedStateStore.setShouldRevertLastEquippedState(false)
				end

				local equippedAssets = object:getState().AvatarExperience.AvatarEditor.Character.EquippedAssets

				if not equippedAssets or not equippedAssets[p14] or equippedAssets[p14][p5] == nil then
					local tryOnItemReducerKey = getTryOnItemReducerKey(p5, p6)
					local order = tryOnItems[tryOnItemReducerKey] and tryOnItems[tryOnItemReducerKey].order
					object:dispatch(module22(
						p14,
						p5,
						p15,
						false,
						order,
						tryOnItems[tryOnItemReducerKey] and {
							position = tryOnItems[tryOnItemReducerKey].position,
							rotation = tryOnItems[tryOnItemReducerKey].rotation,
							scale = tryOnItems[tryOnItemReducerKey].scale
						}
					))
				end
			end
		end

		return Promise.resolve(v7)
	end
end

return handlePurchaseSuccess
