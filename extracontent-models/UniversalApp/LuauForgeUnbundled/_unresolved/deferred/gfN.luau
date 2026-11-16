local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local Promise = require(CorePackages.Packages.Promise)
local module = require("@luauforge/bundled/dwM")
local Cryo = require(CorePackages.Packages.Cryo)
local tutils = require(CorePackages.Packages.tutils)
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local module7 = require("@luauforge/bundled/dHL")
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors

local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local module9 = require("@luauforge/bundled/dME")
local module10 = require("@luauforge/bundled/dMx")
local widgetConstants = AvatarExperienceCatalog.WidgetConstants

local module11 = require("@luauforge/bundled/fuX")
local module12 = require("@luauforge/bundled/ecW")
local module13 = require("@luauforge/deferred/fuZ")
local module14 = require("@luauforge/bundled/dRQ")
local itemData = AvatarExperienceCommon.State.Selectors.ItemData
local module15 = require("@luauforge/bundled/dwB")

local module16 = require("@luauforge/bundled/dMV")
local module17 = require("@luauforge/bundled/dNj")
local module18 = require("@luauforge/bundled/fvd")

local module19 = require("@luauforge/bundled/fuO")
local module20 = require("@luauforge/deferred/fvf")

local module21 = require("@luauforge/bundled/fuQ")

local module22 = require("@luauforge/bundled/fuS")
local module23 = require("@luauforge/bundled/fuC")
local module24 = require("@luauforge/bundled/fvg")
local applyProfileConfiguration = module7.Actions.ApplyProfileConfiguration
local module25 = require("@luauforge/bundled/dCh")
local removeFromTryOn = module7.Actions.RemoveFromTryOn
local module26 = require("@luauforge/deferred/fvk")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local selectSearchKeyword = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Selectors.selectSearchKeyword
local findItemInTryOnItems = AvatarExperienceCommon.Utils.findItemInTryOnItems
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey

local avatarLastEquippedStateStore = AvatarExperienceCommon.Stores.AvatarLastEquippedStateStore.avatarLastEquippedStateStore
local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogEnums

local sendUnifiedEventForDeferredAction = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendUnifiedEventForDeferredAction

local avatarScreenProperties = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").AvatarRoute.AvatarScreenProperties
local cartIdService = AvatarExperienceAnalytics.Lib.CartIdService
local mapAnalyticsMetadataFields = AvatarExperienceAnalytics.Utils.mapAnalyticsMetadataFields
local getWidgetAttributionFields = AvatarExperienceAnalytics.Utils.getWidgetAttributionFields
local unifiedSelectionListStore = AvatarExperienceAnalytics.Store.UnifiedSelectionListStore

local module27 = require("@luauforge/deferred/gfO")

local isEconomicRestrictionResponse = require("@luauforge/deferred/gfP").Utility.isEconomicRestrictionResponse
local fFlagAXFixPurchaseSurfaceLogging = SharedFlags.FFlagAXFixPurchaseSurfaceLogging
local fFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport

local fFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup = AvatarExperienceFlags.FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup
local fFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local fFlagSignalsNavP3gAvatarExperience = SharedFlags.FFlagSignalsNavP3gAvatarExperience
local getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
local fFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads
local fFlagAXBackgroundsCustomizeHydration = AvatarExperienceFlags.FFlagAXBackgroundsCustomizeHydration
local fFlagEnableNonCollectiblePurchaseCountersLua = SharedFlags.FFlagEnableNonCollectiblePurchaseCountersLua

local module28 = require("@luauforge/deferred/gfQ")

local v5 = { HttpError = Enum.HttpError.OK }

local v6 = {
	toastMessage = "Feature.Catalog.Label.Purchased",
	isLocalized = false,
	toastType = module15.SuccessConfirmation
}

local function updateRobux(p2, object)
	local localUserId = object:getState().LocalUserId
	module.isNonEmptyString(localUserId, "Thunk.PurchaseProduct.updateRobux.localUserId")

	if typeof(localUserId) == "string" and localUserId ~= "" then
		object:dispatch(module11(p2, localUserId, true))
	end
end

local function removeFromTryOn2(object, responseBody)
	local state = object:getState()
	local tryOnItems = state.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

	local v7 = responseBody.assetId

	if not v7 and responseBody.productId then
		for k, tryOnItem in tryOnItems do
			if tryOnItem.itemType == module10.ItemType.Asset then
				continue
			end

			local bundleInfo = state.AvatarExperience.Common.BundleInfos[k]
			local id = bundleInfo and bundleInfo.product.id

			if id and id == tostring(responseBody.productId) then
				v7 = tryOnItem.itemId
			end
		end
	end

	local v8

	if v7 then
		v8 = findItemInTryOnItems(tryOnItems, v7)
		object:dispatch(removeFromTryOn((tostring(v7))))
	end

	return v8
end

local function purchaseProductKeyMapper(p2)
	return module9.PurchaseProductKey .. tostring(p2)
end

return function(p2, p3, p4, p5, p6, p7, p8, p9, p10, data, p11, p12, p13, p14, p15, p16, p17, p18, p19, callback, p20)
	return performFetch.Single(module9.PurchaseProductKey .. tostring(p3), function(object)
		local v7 = itemData(object:getState().AvatarExperience.Common, p6, p7)
		local isResellable = module14.IsResellable(v7)

		local v8 = nil

		local collectibles = object:getState().AvatarExperience.Common.Collectibles
		local collectiblesItemInfo = collectibles.CollectiblesItemInfo
		local v9

		if p15 and collectiblesItemInfo[p15] then
			local localUserId = object:getState().LocalUserId
			local guid = HttpService:GenerateGUID(false)

			if p16 == nil then
				local collectibleProductId = collectiblesItemInfo[p15].collectibleProductId

				v9 = GetExperienceSourceLanguage.PurchaseCollectibleItem(
					p2,
					p15,
					collectibleProductId,
					p4,
					p5,
					p17,
					localUserId,
					guid,
					p20
				)
			else
				local collectiblesResellersInstance = collectibles.CollectiblesResellersInstances[p15]

				local v10 = collectiblesResellersInstance and collectiblesResellersInstance.Instances[p16]
				local collectibleProductId = v10 and v10.collectibleProductId

				if collectibleProductId then
					v9 = GetExperienceSourceLanguage.PurchaseCollectibleItemResale(
						p2,
						p15,
						p16,
						collectibleProductId,
						p4,
						p5,
						p17,
						localUserId,
						guid
					)
				else
					v9 = Promise.reject({
						reason = "CollectibleProductIdNotFound",
						HttpError = Enum.HttpError.OK
					})
				end
			end
		else
			if fFlagEnableNonCollectiblePurchaseCountersLua then
				v8 = module28.reportCatalogNonCollectiblePurchase(v7, p7, p15, p10)
			end

			v9 = GetExperienceSourceLanguage.PurchaseProduct(p2, p3, p4, p5, p10)
		end

		return v9:andThen(function(p21)
			local responseBody = p21.responseBody

			if type(responseBody) == "table" then
				if isEconomicRestrictionResponse(responseBody) and callback then
					callback(responseBody)
					return Promise.resolve(responseBody)
				end

				if isResellable then
					if p15 then
						object:dispatch(module21(p2, p15, nil, module9.MaxResellersPerPage))

						object:dispatch(module22(p2, p15, object:getState().LocalUserId))
					else
						object:dispatch(module19(p2, p6, nil, module9.MaxResellersPerPage, true))

						object:dispatch(module20(p2, p6, object:getState().LocalUserId))
					end
				end

				if responseBody.purchased then
					if fFlagEnableNonCollectiblePurchaseCountersLua and v8 then
						module28.reportCatalogLegacyEndpointPurchaseSuccess(v8)
					end

					if p7 == module10.ItemType.Asset then
						object:dispatch(module16(p6, true))

						if fFlagAXInventoryDurablesSupport then
							object:dispatch(module23(p2, data, p6, p7, true))
						end
					else
						object:dispatch(module17(p6, true))
					end

					local v10 = p2
					local v11 = object
					local localUserId = v11:getState().LocalUserId
					module.isNonEmptyString(localUserId, "Thunk.PurchaseProduct.updateRobux.localUserId")

					if typeof(localUserId) == "string" and localUserId ~= "" then
						v11:dispatch(module11(v10, localUserId, true))
					end

					local v12 = nil
					pcall(function()
						local v13

						if fFlagSignalsNavP3gAvatarExperience then
							v13 = getLegacyNavigationStore(false).getCurrentRoute(false)
						elseif fFlagUseNavigationSelectors then
							v13 = selectors.selectCurrentRoactNavigationRoute(object:getState())
						else
							v13 = object:getState().Navigation and object:getState().Navigation.currentRoute
						end

						v12 = v13
						local v14

						if
							v12
							and v12.params
							and v12.params.fromAvatarRoute
							and v12.params.fromAvatarRoute.opaque
						then
							v14 = avatarScreenProperties[v12.params.fromAvatarRoute.opaque.name]
						end

						local v15

						if p20 then
							v15 = module9.TimedOptionsMap[p20]
						else
							v15 = unifiedEventLogEnums.MarketplaceTimedOption.PERMANENT
						end

						local v16 = nil

						if fFlagAXMISEnableMultiShoppingUnifiedEvents then
							if p7 == "Asset" then
								v16 = unifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
							elseif p7 == "Bundle" then
								v16 = unifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
							end
						end

						local join = Cryo.Dictionary.join
						local analyticsMetadata = object:getState().AvatarExperience.AnalyticsMetadata
						local v17 = {
							action = unifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_SUCCESS,
							cartId = 0,
							itemId = 0,
							itemType = 0,
							keyword = 0,
							surface = 0,
							widgetTimedOption = 0,
							organicTimedOption = 0
						}

						local v18 = if fFlagAXMISEnableMultiShoppingUnifiedEvents then cartIdService.getCartId() else nil
						v17.cartId = v18

						v17.itemId = if fFlagAXMISEnableMultiShoppingUnifiedEvents then p6 else nil

						if not fFlagAXMISEnableMultiShoppingUnifiedEvents then
							v16 = nil
						end

						v17.itemType = v16
						v17.keyword = selectSearchKeyword(object:getState())
						local v20 = if v14 and v14.analyticsData then v14.analyticsData.unifiedLoggingSurface else nil
						v17.surface = v20

						v17.widgetTimedOption = if p18 then v15 else nil

						if p18 then
							v15 = nil
						end

						v17.organicTimedOption = v15
						local v22 = join(analyticsMetadata, v17)

						if fFlagAXUnifiedEventStrictPayloads then
							v22 = mapAnalyticsMetadataFields(v22)
						end

						local v24 = if fFlagAXUnifiedEventStrictPayloads then getWidgetAttributionFields(p18) else nil
						sendUnifiedEventForDeferredAction(v22, v24)
					end)

					if fFlagAXMISEnableMultiShoppingUnifiedEvents then
						cartIdService.refreshCartId()
						unifiedSelectionListStore.clearSelectionList()
					end

					local tryOnItems = object:getState().AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

					if p7 == module10.ItemType.Asset then
						data.purchaseAsset(
							p6,
							p8,
							p4,
							p12,
							module26.checkTryOnHasAdjustments(tryOnItems, (tostring(p6))),
							p19
						)
					elseif p7 == module10.ItemType.Bundle then
						data.purchaseBundle(p6, p8, p4, p12, p19)
					end

					if p18 then
						local joined = Cryo.Dictionary.join(p18, { totalRobux = p4 })
						data.widgetInteractionV2(joined, widgetConstants.ActionType.PURCHASE_SUCCESS)
					end

					if not p13 then
						local requestId = object:getState().AvatarExperience.Common.Widgets.WidgetInfo.RequestId

						local v13 = nil

						local v14 = nil
						local v15 = nil
						local state = object:getState()

						if module27() then
							v13 = selectSearchKeyword(state)
							v14, v15 = module14.getCategoryAndSubcategory(state)
						else
							local fromAvatarRoute = v12 and v12.params and v12.params.fromAvatarRoute
							local current = fromAvatarRoute and fromAvatarRoute.current

							if current and current.name == avatarScreen.CatalogSearch then
								local key = current.key
								v13 = state.Search
									and state.Search.SearchesInCatalog[key]
									and state.Search.SearchesInCatalog[key].keyword
							end

							local currentCategoryNames = module14.getCurrentCategoryNames(state)

							local v16 = current and current.name == avatarScreen.CatalogSearch

							if currentCategoryNames then
								if v16 then
									v14 = currentCategoryNames.catalogSearchCategory or v14
									v15 = currentCategoryNames.catalogSearchSubcategory or v15
								else
									v14 = currentCategoryNames.catalogCategory or v14
									v15 = currentCategoryNames.catalogSubcategory or v15
								end
							end
						end

						local avatarShopBuyItem = data.avatarShopBuyItem

						local analyticsMetadata = object:getState().AvatarExperience.AnalyticsMetadata

						local v20 = if fFlagAXFixPurchaseSurfaceLogging and p11 then p11.getParam(module10.NavigationParams.fromSurface) else nil
						avatarShopBuyItem(p6, p7, p4, p14, requestId, v13, v14, v15, analyticsMetadata, v20)

						object:dispatch(module25(v6))
					end

					if p13 then
						local v13 = removeFromTryOn2(object, responseBody)

						if v13 then
							if responseBody.assetIsWearable == false and v13.itemId ~= nil then
								responseBody = Cryo.Dictionary.join(responseBody, {
									bundleId = v13.itemId,
									tryOnBundleInfo = v13.bundleInfo
								})
							end

							responseBody = Cryo.Dictionary.join(responseBody, {
								itemSubType = p8,
								overrideOrder = v13.order
							})
						end
					end

					object:dispatch(module18(p11))

					if p9 then
						if
							fFlagAXBackgroundsCustomizeHydration
							and p7 == module10.ItemType.Asset
							and p8 == module10.AssetTypeIdStrings.AvatarBackground
						then
							object:dispatch(applyProfileConfiguration({
								BackgroundAssetId = tonumber(p6)
							}))
						elseif
							p7 == module10.ItemType.Asset
							and p8 ~= module10.AssetTypeIdStrings.EmoteAnimation
						then
							if fFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup then
								avatarLastEquippedStateStore.setShouldRevertLastEquippedState(false)
							end

							local equippedAssets = object:getState().AvatarExperience.AvatarEditor.Character.EquippedAssets

							if
								not equippedAssets
								or not equippedAssets[p8]
								or equippedAssets[p8][p6] == nil
							then
								local tryOnItemReducerKey = getTryOnItemReducerKey(p6, p7)
								local order = tryOnItems[tryOnItemReducerKey]
									and tryOnItems[tryOnItemReducerKey].order
								local v13 = tryOnItems[tryOnItemReducerKey]
									and {
										position = tryOnItems[tryOnItemReducerKey].position,
										rotation = tryOnItems[tryOnItemReducerKey].rotation,
										scale = tryOnItems[tryOnItemReducerKey].scale
									}

								object:dispatch(module24(
									p8,
									p6,
									p11,
									tutils.fieldCount(tryOnItems) > 1,
									order,
									v13
								))
							end
						end
					end

					return Promise.resolve(responseBody)
				end

				if not p13 then
					object:dispatch(module13(responseBody))
				end

				return Promise.reject(responseBody)
			else
				local v10 = v5
				logging.warn("Response from PurchaseProduct is malformed!")

				if not p13 then
					object:dispatch(module12(v10))
				end

				return Promise.reject(v10)
			end
		end, function(p21)
			if type(p21) ~= "table" or p21.HttpError == nil then
				p21 = v5
			end

			if not p13 then
				object:dispatch(module12(p21))
			end

			return Promise.reject(p21)
		end)
	end)
end
