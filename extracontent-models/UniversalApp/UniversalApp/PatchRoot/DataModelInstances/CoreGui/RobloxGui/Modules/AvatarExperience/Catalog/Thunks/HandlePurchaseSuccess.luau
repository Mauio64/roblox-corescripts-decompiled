local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Promise = require(CorePackages.Packages.Promise)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local WidgetConstants = AvatarExperienceCatalog.WidgetConstants
local ApiFetchEconomyCurrency = require(Modules.LuaApp.Thunks.ApiFetchEconomyCurrency)
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
local AccessoryAdjustmentUtils = require(Modules.AvatarExperience.AccessoryAdjustment.AccessoryAdjustmentUtils)
local selectSearchKeyword = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).State.Selectors.selectSearchKeyword
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local avatarLastEquippedStateStore = AvatarExperienceCommon.Stores.AvatarLastEquippedStateStore.avatarLastEquippedStateStore
local UnifiedEventLogEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogEnums
local sendUnifiedEventForDeferredAction = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendUnifiedEventForDeferredAction
local AvatarScreenProperties = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).AvatarRoute.AvatarScreenProperties
local mutedError = require(CorePackages.Workspace.Packages.Loggers).mutedError
local CartIdService = AvatarExperienceAnalytics.Lib.CartIdService
local UnifiedSelectionListStore = AvatarExperienceAnalytics.Store.UnifiedSelectionListStore
local FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup = AvatarExperienceFlags.FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup
local FFlagAXFixPurchaseSurfaceLogging = SharedFlags.FFlagAXFixPurchaseSurfaceLogging
local FFlagAXUnifiedPurchaseExtendRentalsFix = AvatarExperienceFlags.FFlagAXUnifiedPurchaseExtendRentalsFix
local FFlagAXMISEnableMultiShoppingUnifiedEvents = AvatarExperienceFlags.FFlagAXMISEnableMultiShoppingUnifiedEvents
local FFlagAXBackgroundsCustomizeHydration = AvatarExperienceFlags.FFlagAXBackgroundsCustomizeHydration
local FFlagAXHideUnifiedPurchaseFlowSuccessToastMarketplace = AvatarExperienceFlags.FFlagAXHideUnifiedPurchaseFlowSuccessToastMarketplace
local FFlagSkipCompletionModalForMarketplace = SharedFlags.FFlagSkipCompletionModalForMarketplace

local function updateRobux(p1, p2) -- line: 63
	-- upvalues: ArgCheck (copy), ApiFetchEconomyCurrency (copy)
	local LocalUserId = p2:getState().LocalUserId

	ArgCheck.isNonEmptyString(LocalUserId, "Thunk.PurchaseProduct.updateRobux.localUserId")

	if typeof(LocalUserId) == "string" and LocalUserId ~= "" then
		p2:dispatch(ApiFetchEconomyCurrency(p1, LocalUserId, true))
	end
end

local t1 = {
	toastMessage = "Feature.Catalog.Label.Purchased",
	isLocalized = false,
	toastType = ToastType.SuccessConfirmation
}

local function handlePurchaseSuccess(p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17) -- line: 78
	-- upvalues: ItemData (copy), CatalogUtils (copy), FetchCollectibResellersInstances (copy), CatalogConstants (copy), FetchCollectibleResellableInstances (copy), FetchAssetResellers (copy), FetchSellPageData (copy), Constants (copy), SetAssetOwned (copy), FFlagAXUnifiedPurchaseExtendRentalsFix (copy), FetchAssetOrBundleInfo (copy), SetBundleOwned (copy), ArgCheck (copy), ApiFetchEconomyCurrency (copy), AvatarScreenProperties (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), UnifiedEventLogEnums (copy), sendUnifiedEventForDeferredAction (copy), Cryo (copy), CartIdService (copy), selectSearchKeyword (copy), mutedError (copy), UnifiedSelectionListStore (copy), AccessoryAdjustmentUtils (copy), WidgetConstants (copy), FFlagAXFixPurchaseSurfaceLogging (copy), FFlagAXHideUnifiedPurchaseFlowSuccessToastMarketplace (copy), FFlagSkipCompletionModalForMarketplace (copy), SetCurrentToastMessage (copy), t1 (copy), CloseAllItemDetails (copy), FFlagAXBackgroundsCustomizeHydration (copy), ApplyProfileConfiguration (copy), FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup (copy), avatarLastEquippedStateStore (copy), getTryOnItemReducerKey (copy), ToggleEquipAsset (copy), Promise (copy), SetPurchaseErrorToast (copy)
	return function(p18) -- line: 95
		-- upvalues: ItemData (copy), p6 (copy), p7 (copy), CatalogUtils (copy), p3 (copy), p8 (copy), FetchCollectibResellersInstances (copy), p5 (copy), CatalogConstants (copy), FetchCollectibleResellableInstances (copy), FetchAssetResellers (copy), FetchSellPageData (copy), Constants (copy), SetAssetOwned (copy), FFlagAXUnifiedPurchaseExtendRentalsFix (copy), FetchAssetOrBundleInfo (copy), p9 (copy), SetBundleOwned (copy), ArgCheck (copy), ApiFetchEconomyCurrency (copy), p4 (copy), p12 (copy), AvatarScreenProperties (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), UnifiedEventLogEnums (copy), p14 (copy), sendUnifiedEventForDeferredAction (copy), Cryo (copy), CartIdService (copy), selectSearchKeyword (copy), mutedError (copy), UnifiedSelectionListStore (copy), p16 (copy), p15 (copy), p10 (copy), AccessoryAdjustmentUtils (copy), p11 (copy), WidgetConstants (copy), p13 (copy), FFlagAXFixPurchaseSurfaceLogging (copy), p17 (copy), FFlagAXHideUnifiedPurchaseFlowSuccessToastMarketplace (copy), FFlagSkipCompletionModalForMarketplace (copy), SetCurrentToastMessage (copy), t1 (copy), CloseAllItemDetails (copy), FFlagAXBackgroundsCustomizeHydration (copy), ApplyProfileConfiguration (copy), FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup (copy), avatarLastEquippedStateStore (copy), getTryOnItemReducerKey (copy), ToggleEquipAsset (copy), Promise (copy), SetPurchaseErrorToast (copy)
		local v70 = ItemData(p18:getState().AvatarExperience.Common, p6, p7)
		local v71 = CatalogUtils.IsResellable(v70)
		local v72 = p3

		if type(v72) == "table" then
			if v71 then
				if p8 then
					p18:dispatch(FetchCollectibResellersInstances(p5, p8, nil, CatalogConstants.MaxResellersPerPage))

					local LocalUserId = p18:getState().LocalUserId

					p18:dispatch(FetchCollectibleResellableInstances(p5, p8, LocalUserId))
				else
					p18:dispatch(FetchAssetResellers(p5, p6, nil, CatalogConstants.MaxResellersPerPage, true))

					local LocalUserId = p18:getState().LocalUserId

					p18:dispatch(FetchSellPageData(p5, p6, LocalUserId))
				end
			end

			if v72.purchased then
				if p7 == Constants.ItemType.Asset then
					p18:dispatch(SetAssetOwned(p6, true))

					if FFlagAXUnifiedPurchaseExtendRentalsFix then
						p18:dispatch(FetchAssetOrBundleInfo(p5, p9, p6, p7, true))
					end
				else
					p18:dispatch(SetBundleOwned(p6, true))
				end

				local v75 = p5
				local LocalUserId = p18:getState().LocalUserId

				ArgCheck.isNonEmptyString(LocalUserId, "Thunk.PurchaseProduct.updateRobux.localUserId")

				if typeof(LocalUserId) == "string" and LocalUserId ~= "" then
					p18:dispatch(ApiFetchEconomyCurrency(v75, LocalUserId, true))
				end

				local ok, result = pcall(function() -- line: 134
					-- upvalues: p4 (copy), Constants (copy), p12 (copy), AvatarScreenProperties (copy), FFlagAXMISEnableMultiShoppingUnifiedEvents (copy), p7 (copy), UnifiedEventLogEnums (copy), p14 (copy), sendUnifiedEventForDeferredAction (copy), Cryo (copy), p18 (copy), CartIdService (copy), selectSearchKeyword (copy), p6 (copy)
					local v90 = false

					if p4[Constants.WearAfterPurchasePostPurchaseActionKey] then
						v90 = p4[Constants.WearAfterPurchasePostPurchaseActionKey]
					end

					local v91 = nil

					if p12 and p12.current and p12.opaque then
						v91 = AvatarScreenProperties[p12.opaque.name]
					end

					local ASSET = nil

					if FFlagAXMISEnableMultiShoppingUnifiedEvents then
						if p7 == "Asset" then
							ASSET = UnifiedEventLogEnums.MarketplaceUnifiedItemType.ASSET
						elseif p7 == "Bundle" then
							ASSET = UnifiedEventLogEnums.MarketplaceUnifiedItemType.BUNDLE
						end
					end

					local v93 = p14 or {
						widgetType = nil
					}

					sendUnifiedEventForDeferredAction(Cryo.Dictionary.join(p18:getState().AvatarExperience.AnalyticsMetadata, {
						action = UnifiedEventLogEnums.MarketplaceUnifiedAction.PURCHASE_SUCCESS,
						cartId = if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else CartIdService.getCartId(),
						keyword = selectSearchKeyword(p18:getState()),
						itemId = if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else p6,
						itemType = if not FFlagAXMISEnableMultiShoppingUnifiedEvents then nil else ASSET,
						surface = if not v91 or not v91.analyticsData then nil else v91.analyticsData.unifiedLoggingSurface,
						widgetItemWearAfterPurchase = if not v93.widgetType then nil else v90,
						organicItemWearAfterPurchase = if not v93.widgetType then v90 else nil
					}))
				end)

				if not ok then
					mutedError(result)
				end

				if FFlagAXMISEnableMultiShoppingUnifiedEvents then
					CartIdService.refreshCartId()
					UnifiedSelectionListStore.clearSelectionList()
				end

				local TryOnItems = p18:getState().AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

				if p7 == Constants.ItemType.Asset then
					p9.purchaseAsset(p6, p16, p15, p10, AccessoryAdjustmentUtils.checkTryOnHasAdjustments(TryOnItems, (tostring(p6))), p11)
				elseif p7 == Constants.ItemType.Bundle then
					p9.purchaseBundle(p6, p16, p15, p10, p11)
				end

				if p14 then
					local v80 = Cryo.Dictionary.join(p14, {
						totalRobux = p15
					})

					p9.widgetInteractionV2(v80, WidgetConstants.ActionType.PURCHASE_SUCCESS)
				end

				local RequestId = p18:getState().AvatarExperience.Common.Widgets.WidgetInfo.RequestId
				local v82 = p18:getState()
				local v83 = selectSearchKeyword(v82)
				local v84, v85 = CatalogUtils.getCategoryAndSubcategory(v82)

				p9.avatarShopBuyItem(p6, p7, p15, p13, RequestId, v83, v84, v85, p18:getState().AvatarExperience.AnalyticsMetadata, if not FFlagAXFixPurchaseSurfaceLogging or not p17 then nil else p17.getParam(Constants.NavigationParams.fromSurface))

				if not FFlagAXHideUnifiedPurchaseFlowSuccessToastMarketplace or FFlagSkipCompletionModalForMarketplace then
					p18:dispatch(SetCurrentToastMessage(t1))
				end

				p18:dispatch(CloseAllItemDetails(p17))

				if p4[Constants.WearAfterPurchasePostPurchaseActionKey] then
					if FFlagAXBackgroundsCustomizeHydration and p7 == Constants.ItemType.Asset and p16 == Constants.AssetTypeIdStrings.AvatarBackground then
						p18:dispatch(ApplyProfileConfiguration({
							BackgroundAssetId = tonumber(p6)
						}))
					elseif p7 == Constants.ItemType.Asset and p16 ~= Constants.AssetTypeIdStrings.EmoteAnimation then
						if FFlagAXRevertEquippedAssetsAfterLayeringTryOnMakeup then
							avatarLastEquippedStateStore.setShouldRevertLastEquippedState(false)
						end

						local EquippedAssets = p18:getState().AvatarExperience.AvatarEditor.Character.EquippedAssets

						if not EquippedAssets or (not EquippedAssets[p16] or EquippedAssets[p16][p6] == nil) then
							local v87 = getTryOnItemReducerKey(p6, p7)
							local v88 = TryOnItems[v87] and TryOnItems[v87].order
							local v89 = TryOnItems[v87] and {
								position = TryOnItems[v87].position,
								rotation = TryOnItems[v87].rotation,
								scale = TryOnItems[v87].scale
							}

							p18:dispatch(ToggleEquipAsset(p16, p6, p17, false, v88, v89))
						end
					end
				end

				return Promise.resolve(v72)
			end

			p18:dispatch(SetPurchaseErrorToast(v72))

			return Promise.reject(v72)
		end
	end
end

return handlePurchaseSuccess
