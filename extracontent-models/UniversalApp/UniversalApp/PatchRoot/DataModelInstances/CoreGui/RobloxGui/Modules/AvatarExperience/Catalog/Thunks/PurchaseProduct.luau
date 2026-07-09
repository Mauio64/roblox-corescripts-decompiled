local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging
local Promise = require(CorePackages.Packages.Promise)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Cryo = require(CorePackages.Packages.Cryo)
local tutils = require(CorePackages.Packages.tutils)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local WidgetConstants = AvatarExperienceCatalog.WidgetConstants
local ApiFetchEconomyCurrency = require(Modules.LuaApp.Thunks.ApiFetchEconomyCurrency)
local SetNetworkingErrorToast = require(Modules.LuaApp.Thunks.SetNetworkingErrorToast)
local SetPurchaseErrorToast = require(Modules.LuaApp.Thunks.SetPurchaseErrorToast)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local SetAssetOwned = require(Modules.AvatarExperience.Common.Actions.SetAssetOwned)
local SetBundleOwned = require(Modules.AvatarExperience.Common.Actions.SetBundleOwned)
local CloseAllItemDetails = require(Modules.AvatarExperience.Common.Thunks.CloseAllItemDetails)
local FetchAssetResellers = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetResellers)
local FetchSellPageData = require(Modules.AvatarExperience.Catalog.Thunks.FetchSellPageData)
local FetchCollectibResellersInstances = require(Modules.AvatarExperience.Catalog.Thunks.FetchCollectibResellersInstances)
local FetchCollectibleResellableInstances = require(Modules.AvatarExperience.Catalog.Thunks.FetchCollectibleResellableInstances)
local FetchAssetOrBundleInfo = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetOrBundleInfo)
local ToggleEquipAsset = require(Modules.AvatarExperience.AvatarEditor.Thunks.ToggleEquipAsset)
local ApplyProfileConfiguration = AvatarExperienceRodux.Actions.ApplyProfileConfiguration
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local RemoveFromTryOn = AvatarExperienceRodux.Actions.RemoveFromTryOn

require(Modules.AvatarExperience.Common.Reducers.OutfitTryOn)

local AccessoryAdjustmentUtils = require(Modules.AvatarExperience.AccessoryAdjustment.AccessoryAdjustmentUtils)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local selectSearchKeyword = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).State.Selectors.selectSearchKeyword
local findItemInTryOnItems = AvatarExperienceCommon.Utils.findItemInTryOnItems
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local avatarLastEquippedStateStore = AvatarExperienceCommon.Stores.AvatarLastEquippedStateStore.avatarLastEquippedStateStore
local UnifiedEventLogEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogEnums
local sendUnifiedEventForDeferredAction = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendUnifiedEventForDeferredAction
local AvatarScreenProperties = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.AvatarScreenProperties
local CartIdService = AvatarExperienceAnalytics.Lib.CartIdService
local UnifiedSelectionListStore = AvatarExperienceAnalytics.Store.UnifiedSelectionListStore
local GetFFlagAXItemDetailsAnalyticsV2 = require(Modules.AvatarExperience.Flags.GetFFlagAXItemDetailsAnalyticsV2)
local isEconomicRestrictionResponse = require(CorePackages.Workspace.Packages.IAPExperience).Utility.isEconomicRestrictionResponse
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXFixPurchaseSurfaceLogging = SharedFlags.FFlagAXFixPurchaseSurfaceLogging
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup = AvatarExperienceFlags.FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup
local FFlagUseNavigationSelectors = SharedFlags.FFlagUseNavigationSelectors
local FFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local FFlagAXBackgroundsCustomizeHydration = AvatarExperienceFlags.FFlagAXBackgroundsCustomizeHydration
local t1 = {
	HttpError = Enum.HttpError.OK
}
local t2 = {
	toastMessage = "Feature.Catalog.Label.Purchased",
	isLocalized = false,
	toastType = ToastType.SuccessConfirmation
}

local function updateRobux(p1, p2) -- line: 84
	-- upvalues: ArgCheck (copy), ApiFetchEconomyCurrency (copy)
	local LocalUserId = p2:getState().LocalUserId

	ArgCheck.isNonEmptyString(LocalUserId, "Thunk.PurchaseProduct.updateRobux.localUserId")

	if typeof(LocalUserId) == "string" and LocalUserId ~= "" then
		p2:dispatch(ApiFetchEconomyCurrency(p1, LocalUserId, true))
	end
end
local function removeFromTryOn(p3, p4) -- line: 96
	-- upvalues: Constants (copy), findItemInTryOnItems (copy), RemoveFromTryOn (copy)
	local v69 = p3:getState()
	local TryOnItems = v69.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	local assetId = p4.assetId

	if not assetId and p4.productId then
		for v72, v73 in TryOnItems do
			if v73.itemType ~= Constants.ItemType.Asset then
				local v74 = v69.AvatarExperience.Common.BundleInfos[v72]
				local v75 = v74 and v74.product.id

				if v75 and v75 == tostring(p4.productId) then
					assetId = v73.itemId
				end
			end
		end
	end

	local v76 = nil

	if assetId then
		v76 = findItemInTryOnItems(TryOnItems, assetId)
		p3:dispatch(RemoveFromTryOn((tostring(assetId))))
	end

	return v76
end
local function purchaseProductKeyMapper(p5) -- line: 127
	-- upvalues: CatalogConstants (copy)
	return CatalogConstants.PurchaseProductKey .. tostring(p5)
end

return function(p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, s1: string?, s2: string?, s3: string?, s4: string?, p19, b1: boolean?, p20: ((...any) -> ...any)?, n1: number?) -- line: 131
	-- upvalues: PerformFetch (copy), CatalogConstants (copy), ItemData (copy), CatalogUtils (copy), HttpService (copy), Promise (copy), WebApi (copy), isEconomicRestrictionResponse (copy), FetchCollectibResellersInstances (copy), FetchCollectibleResellableInstances (copy), FetchAssetResellers (copy), FetchSellPageData (copy), Constants (copy), SetAssetOwned (copy), FFlagAXInventoryDurablesSupport (copy), FetchAssetOrBundleInfo (copy), SetBundleOwned (copy), ArgCheck (copy), ApiFetchEconomyCurrency (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), AvatarScreenProperties (copy), UnifiedEventLogEnums (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), sendUnifiedEventForDeferredAction (copy), Cryo (copy), CartIdService (copy), selectSearchKeyword (copy), UnifiedSelectionListStore (copy), AccessoryAdjustmentUtils (copy), WidgetConstants (copy), GetFFlagAXItemDetailsAnalyticsV2 (copy), AvatarScreen (copy), FFlagAXFixPurchaseSurfaceLogging (copy), SetCurrentToastMessage (copy), t2 (copy), removeFromTryOn (copy), CloseAllItemDetails (copy), FFlagAXBackgroundsCustomizeHydration (copy), ApplyProfileConfiguration (copy), FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup (copy), avatarLastEquippedStateStore (copy), getTryOnItemReducerKey (copy), FFlagAXMISEnableMultiShopping (copy), tutils (copy), ToggleEquipAsset (copy), SetPurchaseErrorToast (copy), t1 (copy), Logging (copy), SetNetworkingErrorToast (copy)
	return PerformFetch.Single(CatalogConstants.PurchaseProductKey .. tostring(p7), function(p21) -- line: 154
		-- upvalues: ItemData (copy), p10 (copy), p11 (copy), CatalogUtils (copy), s2 (copy), HttpService (copy), s3 (copy), Promise (copy), WebApi (copy), p6 (copy), p8 (copy), p9 (copy), s4 (copy), n1 (copy), p7 (copy), p14 (copy), isEconomicRestrictionResponse (copy), p20 (copy), FetchCollectibResellersInstances (copy), CatalogConstants (copy), FetchCollectibleResellableInstances (copy), FetchAssetResellers (copy), FetchSellPageData (copy), Constants (copy), SetAssetOwned (copy), FFlagAXInventoryDurablesSupport (copy), FetchAssetOrBundleInfo (copy), p15 (copy), SetBundleOwned (copy), ArgCheck (copy), ApiFetchEconomyCurrency (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), AvatarScreenProperties (copy), UnifiedEventLogEnums (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), sendUnifiedEventForDeferredAction (copy), Cryo (copy), CartIdService (copy), selectSearchKeyword (copy), p19 (copy), UnifiedSelectionListStore (copy), p12 (copy), p17 (copy), AccessoryAdjustmentUtils (copy), b1 (copy), WidgetConstants (copy), p18 (copy), GetFFlagAXItemDetailsAnalyticsV2 (copy), AvatarScreen (copy), s1 (copy), FFlagAXFixPurchaseSurfaceLogging (copy), p16 (copy), SetCurrentToastMessage (copy), t2 (copy), removeFromTryOn (copy), CloseAllItemDetails (copy), p13 (copy), FFlagAXBackgroundsCustomizeHydration (copy), ApplyProfileConfiguration (copy), FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup (copy), avatarLastEquippedStateStore (copy), getTryOnItemReducerKey (copy), FFlagAXMISEnableMultiShopping (copy), tutils (copy), ToggleEquipAsset (copy), SetPurchaseErrorToast (copy), t1 (copy), Logging (copy), SetNetworkingErrorToast (copy)
		local v100 = ItemData(p21:getState().AvatarExperience.Common, p10, p11)
		local u101 = CatalogUtils.IsResellable(v100)
		local Collectibles = p21:getState().AvatarExperience.Common.Collectibles
		local CollectiblesItemInfo = Collectibles.CollectiblesItemInfo
		local v109

		if s2 and CollectiblesItemInfo[s2] then
			local LocalUserId = p21:getState().LocalUserId
			local guid = HttpService:GenerateGUID(false)

			if s3 ~= nil then
				local v106 = Collectibles.CollectiblesResellersInstances[s2]
				local v107 = v106 and v106.Instances[s3]
				local v108 = v107 and v107.collectibleProductId

				v109 = if v108 then WebApi.PurchaseCollectibleItemResale(p6, s2, s3, v108, p8, p9, s4, LocalUserId, guid) else Promise.reject({
					reason = "CollectibleProductIdNotFound",
					HttpError = Enum.HttpError.OK
				})
			else
				local collectibleProductId = CollectiblesItemInfo[s2].collectibleProductId

				v109 = WebApi.PurchaseCollectibleItem(p6, s2, collectibleProductId, p8, p9, s4, LocalUserId, guid, n1)
			end
		else
			v109 = WebApi.PurchaseProduct(p6, p7, p8, p9, p14)
		end

		return v109:andThen(function(p22) -- line: 217
			-- upvalues: isEconomicRestrictionResponse (copy), p20 (copy), Promise (copy), u101 (ref), s2 (copy), p21 (copy), FetchCollectibResellersInstances (copy), p6 (copy), CatalogConstants (copy), FetchCollectibleResellableInstances (copy), FetchAssetResellers (copy), p10 (copy), FetchSellPageData (copy), p11 (copy), Constants (copy), SetAssetOwned (copy), FFlagAXInventoryDurablesSupport (copy), FetchAssetOrBundleInfo (copy), p15 (copy), SetBundleOwned (copy), ArgCheck (copy), ApiFetchEconomyCurrency (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), AvatarScreenProperties (copy), n1 (copy), UnifiedEventLogEnums (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), sendUnifiedEventForDeferredAction (copy), Cryo (copy), CartIdService (copy), selectSearchKeyword (copy), p19 (copy), UnifiedSelectionListStore (copy), p12 (copy), p8 (copy), p17 (copy), AccessoryAdjustmentUtils (copy), b1 (copy), WidgetConstants (copy), p18 (copy), GetFFlagAXItemDetailsAnalyticsV2 (copy), CatalogUtils (copy), AvatarScreen (copy), s1 (copy), FFlagAXFixPurchaseSurfaceLogging (copy), p16 (copy), SetCurrentToastMessage (copy), t2 (copy), removeFromTryOn (copy), CloseAllItemDetails (copy), p13 (copy), FFlagAXBackgroundsCustomizeHydration (copy), ApplyProfileConfiguration (copy), FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup (copy), avatarLastEquippedStateStore (copy), getTryOnItemReducerKey (copy), FFlagAXMISEnableMultiShopping (copy), tutils (copy), ToggleEquipAsset (copy), SetPurchaseErrorToast (copy), t1 (copy), Logging (copy), SetNetworkingErrorToast (copy)
			local responseBody = p22.responseBody

			if type(responseBody) == "table" then
				if isEconomicRestrictionResponse(responseBody) and p20 then
					p20(responseBody)

					return Promise.resolve(responseBody)
				end

				if u101 then
					if s2 then
						p21:dispatch(FetchCollectibResellersInstances(p6, s2, nil, CatalogConstants.MaxResellersPerPage))

						local LocalUserId = p21:getState().LocalUserId

						p21:dispatch(FetchCollectibleResellableInstances(p6, s2, LocalUserId))
					else
						p21:dispatch(FetchAssetResellers(p6, p10, nil, CatalogConstants.MaxResellersPerPage, true))

						local LocalUserId = p21:getState().LocalUserId

						p21:dispatch(FetchSellPageData(p6, p10, LocalUserId))
					end
				end

				if responseBody.purchased then
					if p11 == Constants.ItemType.Asset then
						p21:dispatch(SetAssetOwned(p10, true))

						if FFlagAXInventoryDurablesSupport then
							p21:dispatch(FetchAssetOrBundleInfo(p6, p15, p10, p11, true))
						end
					else
						p21:dispatch(SetBundleOwned(p10, true))
					end

					local v115 = p6
					local v116 = p21
					local LocalUserId = v116:getState().LocalUserId

					ArgCheck.isNonEmptyString(LocalUserId, "Thunk.PurchaseProduct.updateRobux.localUserId")

					if typeof(LocalUserId) == "string" and LocalUserId ~= "" then
						v116:dispatch(ApiFetchEconomyCurrency(v115, LocalUserId, true))
					end

					local u118 = nil

					pcall(function() -- line: 260
						-- upvalues: u118 (ref), FFlagUseNavigationSelectors (copy), Selectors (copy), p21 (copy), AvatarScreenProperties (copy), n1 (copy), CatalogConstants (copy), UnifiedEventLogEnums (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), p11 (copy), sendUnifiedEventForDeferredAction (copy), Cryo (copy), CartIdService (copy), p10 (copy), selectSearchKeyword (copy), p19 (copy)
						u118 = if not FFlagUseNavigationSelectors then p21:getState().Navigation and p21:getState().Navigation.currentRoute else Selectors.selectCurrentRoactNavigationRoute(p21:getState())

						local v139 = nil

						if u118 and (u118.params and u118.params.fromAvatarRoute and u118.params.fromAvatarRoute.opaque) then
							v139 = AvatarScreenProperties[u118.params.fromAvatarRoute.opaque.name]
						end

						local v140 = if not n1 then UnifiedEventLogEnums.MarketplaceTimedOption.PERMANENT else CatalogConstants.TimedOptionsMap[n1]
						local ASSET = nil

						if FFlagAXMISEnableMultiShoppingUnifiedEvents then
							if p11 == "Asset" then
								ASSET = UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
							elseif p11 == "Bundle" then
								ASSET = UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
							end
						end

						sendUnifiedEventForDeferredAction(Cryo.Dictionary.join(p21:getState().AvatarExperience.AnalyticsMetadata, {
							action = UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_SUCCESS,
							cartId = if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else CartIdService.getCartId(),
							itemId = if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else p10,
							itemType = if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else ASSET,
							keyword = selectSearchKeyword(p21:getState()),
							surface = if not v139 or not v139.analyticsData then nil else v139.analyticsData.unifiedLoggingSurface,
							widgetTimedOption = if not p19 then nil else v140,
							organicTimedOption = if not p19 then v140 else nil
						}))
					end)

					if FFlagAXMISEnableMultiShoppingUnifiedEvents then
						CartIdService.refreshCartId()
						UnifiedSelectionListStore.clearSelectionList()
					end

					local TryOnItems = p21:getState().AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

					if p11 == Constants.ItemType.Asset then
						p15.purchaseAsset(p10, p12, p8, p17, AccessoryAdjustmentUtils.checkTryOnHasAdjustments(TryOnItems, (tostring(p10))), b1)
					elseif p11 == Constants.ItemType.Bundle then
						p15.purchaseBundle(p10, p12, p8, p17, b1)
					end

					if p19 then
						local v120 = Cryo.Dictionary.join(p19, {
							totalRobux = p8
						})

						p15.widgetInteractionV2(v120, WidgetConstants.ActionType.PURCHASE_SUCCESS)
					end

					if not p18 then
						local RequestId = p21:getState().AvatarExperience.Common.Widgets.WidgetInfo.RequestId
						local v122 = nil
						local v123 = nil
						local v124 = nil
						local v125 = p21:getState()

						if GetFFlagAXItemDetailsAnalyticsV2() then
							v122 = selectSearchKeyword(v125)
							v123, v124 = CatalogUtils.getCategoryAndSubcategory(v125)
						else
							local v126 = u118 and (u118.params and u118.params.fromAvatarRoute)
							local v127 = v126 and v126.current

							if v127 and v127.name == AvatarScreen.CatalogSearch then
								local key = v127.key

								v122 = v125.Search and (v125.Search.SearchesInCatalog[key] and v125.Search.SearchesInCatalog[key].keyword)
							end

							local v129 = CatalogUtils.getCurrentCategoryNames(v125)
							local v130 = v127 and v127.name == AvatarScreen.CatalogSearch

							if v129 then
								if v130 then
									v123 = v129.catalogSearchCategory or v123
									v124 = v129.catalogSearchSubcategory or v124
								else
									v123 = v129.catalogCategory or v123
									v124 = v129.catalogSubcategory or v124
								end
							end
						end

						p15.avatarShopBuyItem(p10, p11, p8, s1, RequestId, v122, v123, v124, p21:getState().AvatarExperience.AnalyticsMetadata, if not FFlagAXFixPurchaseSurfaceLogging or not p16 then nil else p16.getParam(Constants.NavigationParams.fromSurface))
						p21:dispatch(SetCurrentToastMessage(t2))
					end

					if p18 then
						local v131 = removeFromTryOn(p21, responseBody)

						if v131 then
							if responseBody.assetIsWearable == false and v131.itemId ~= nil then
								responseBody = Cryo.Dictionary.join(responseBody, {
									bundleId = v131.itemId,
									tryOnBundleInfo = v131.bundleInfo
								})
							end

							responseBody = Cryo.Dictionary.join(responseBody, {
								itemSubType = p12,
								overrideOrder = v131.order
							})
						end
					end

					p21:dispatch(CloseAllItemDetails(p16))

					if p13 then
						if FFlagAXBackgroundsCustomizeHydration and p11 == Constants.ItemType.Asset and p12 == Constants.AssetTypeIdStrings.AvatarBackground then
							p21:dispatch(ApplyProfileConfiguration({
								BackgroundAssetId = tonumber(p10)
							}))
						elseif p11 == Constants.ItemType.Asset and p12 ~= Constants.AssetTypeIdStrings.EmoteAnimation then
							if FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup then
								avatarLastEquippedStateStore.setShouldRevertLastEquippedState(false)
							end

							local EquippedAssets = p21:getState().AvatarExperience.AvatarEditor.Character.EquippedAssets

							if not EquippedAssets or (not EquippedAssets[p12] or EquippedAssets[p12][p10] == nil) then
								local v133 = getTryOnItemReducerKey(p10, p11)
								local v134 = TryOnItems[v133] and TryOnItems[v133].order
								local v135 = TryOnItems[v133] and {
									position = TryOnItems[v133].position,
									rotation = TryOnItems[v133].rotation,
									scale = TryOnItems[v133].scale
								}
								local v136 = false

								if FFlagAXMISEnableMultiShopping then
									v136 = tutils.fieldCount(TryOnItems) > 1
								end

								p21:dispatch(ToggleEquipAsset(p12, p10, p16, v136, v134, v135))
							end
						end
					end

					return Promise.resolve(responseBody)
				end

				if not p18 then
					p21:dispatch(SetPurchaseErrorToast(responseBody))
				end

				return Promise.reject(responseBody)
			end

			local v137 = t1

			Logging.warn("Response from PurchaseProduct is malformed!")

			if not p18 then
				p21:dispatch(SetNetworkingErrorToast(v137))
			end

			return Promise.reject(v137)
		end, function(p23) -- line: 496
			-- upvalues: t1 (copy), p18 (copy), p21 (copy), SetNetworkingErrorToast (copy), Promise (copy)
			if type(p23) ~= "table" or p23.HttpError == nil then
				p23 = t1
			end

			if not p18 then
				p21:dispatch(SetNetworkingErrorToast(p23))
			end

			return Promise.reject(p23)
		end)
	end)
end
