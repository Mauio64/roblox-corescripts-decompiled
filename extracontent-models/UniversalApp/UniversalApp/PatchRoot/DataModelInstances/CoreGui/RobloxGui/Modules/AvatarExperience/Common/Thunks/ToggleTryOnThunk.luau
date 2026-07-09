local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local tutils = require(CorePackages.Packages.tutils)
local AvatarExperienceHeadRefinement = require(CorePackages.Workspace.Packages.AvatarExperienceHeadRefinement)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local getFilteredTryOnItems = AvatarExperienceCatalog.Utils.TryOns.getFilteredTryOnItems
local useMultiItemShoppingFtux = AvatarExperienceCatalog.Hooks.useMultiItemShoppingFtux
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local FetchOutfitInfoFromBundle = require(Modules.AvatarExperience.Catalog.Thunks.FetchOutfitInfoFromBundle)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local Selectors = require(CorePackages.Workspace.Packages.NavigationRodux).Selectors
local Utils = require(Modules.AvatarExperience.Common.Utils)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local ClearTryOns = AvatarExperienceRodux.Actions.ClearTryOns
local StartedWaitingOnLCUpdate = require(Modules.AvatarExperience.Common.Actions.StartedWaitingOnLCUpdate)
local ToggleTryOn = AvatarExperienceRodux.Actions.ToggleTryOn
local CloseAllItemDetails = require(Modules.AvatarExperience.Common.Thunks.CloseAllItemDetails)
local SetOrderForTryOns = AvatarExperienceRodux.Actions.SetOrderForTryOns
local SetOrder = require(Modules.AvatarExperience.LayeredClothingSort.Actions.SetOrder)
local SelectOrderedToggledOnItemsList = require(Modules.AvatarExperience.Common.Selectors.SelectOrderedToggledOnItemsList)
local SelectOrderedToggledOnMakeupItemsList = require(Modules.AvatarExperience.Common.Selectors.SelectOrderedToggledOnMakeupItemsList)
local SelectUpdatedSortOrderForToggledOnItems = require(Modules.AvatarExperience.Common.Selectors.SelectUpdatedSortOrderForToggledOnItems)
local SelectUpdatedSortOrderForToggledOnMakeupItems = require(Modules.AvatarExperience.Common.Selectors.SelectUpdatedSortOrderForToggledOnMakeupItems)
local Utils2 = require(Modules.AvatarExperience.AvatarEditor.Utils)
local FetchAssetOrBundleInfo = require(Modules.AvatarExperience.Catalog.Thunks.FetchAssetOrBundleInfo)
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local isMakeupAssetType = AvatarExperienceCommon.Utils.isMakeupAssetType

require(Modules.AvatarExperience.Common.Types)

local HeadShape = AvatarExperienceHeadRefinement.Enums.HeadShape
local TryOnClassicHeadShape = AvatarExperienceHeadRefinement.Actions.TryOnClassicHeadShape
local v36 = game:DefineFastFlag("AXMISFixItemDetailsClose", false)
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local FFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local FFlagUseNavigationSelectors = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseNavigationSelectors
local FFlagAXEnableExpiredUserLookCheckout = AvatarExperienceFlags.FFlagAXEnableExpiredUserLookCheckout

return function(p1, p2, p3, p4, s1: string, p5, p6, p7, p8, b1: boolean?, b2: boolean?, n1: number?) -- line: 64
	-- upvalues: Constants (copy), Utils (copy), FetchOutfitInfoFromBundle (copy), getTryOnItemReducerKey (copy), FFlagAXEnableExpiredUserLookCheckout (copy), NavigationUtils (copy), AvatarScreenProperties (copy), FFlagAXMISEnableMultiShopping (copy), ClearTryOns (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), v36 (copy), FetchAssetOrBundleInfo (copy), StartedWaitingOnLCUpdate (copy), SelectOrderedToggledOnItemsList (copy), FFlagAXCatalogMakeupSupport (copy), SelectOrderedToggledOnMakeupItemsList (copy), isMakeupAssetType (copy), SelectUpdatedSortOrderForToggledOnMakeupItems (copy), SelectUpdatedSortOrderForToggledOnItems (copy), SetOrder (copy), SetOrderForTryOns (copy), Utils2 (copy), HeadShape (copy), TryOnClassicHeadShape (copy), useMultiItemShoppingFtux (copy), tutils (copy), getFilteredTryOnItems (copy), AvatarScreen (copy), CloseAllItemDetails (copy), CatalogUtils (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), ToggleTryOn (copy), FFlagAXDurablesForMIS (copy)
	return function(p9) -- line: 78
		-- upvalues: p4 (copy), p3 (copy), Constants (copy), Utils (copy), s1 (copy), FetchOutfitInfoFromBundle (copy), p1 (copy), getTryOnItemReducerKey (copy), b1 (copy), FFlagAXEnableExpiredUserLookCheckout (copy), p7 (copy), NavigationUtils (copy), p6 (copy), AvatarScreenProperties (copy), FFlagAXMISEnableMultiShopping (copy), ClearTryOns (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), v36 (copy), FetchAssetOrBundleInfo (copy), p2 (copy), StartedWaitingOnLCUpdate (copy), SelectOrderedToggledOnItemsList (copy), FFlagAXCatalogMakeupSupport (copy), SelectOrderedToggledOnMakeupItemsList (copy), isMakeupAssetType (copy), SelectUpdatedSortOrderForToggledOnMakeupItems (copy), SelectUpdatedSortOrderForToggledOnItems (copy), SetOrder (copy), SetOrderForTryOns (copy), Utils2 (copy), HeadShape (copy), TryOnClassicHeadShape (copy), useMultiItemShoppingFtux (copy), b2 (copy), tutils (copy), getFilteredTryOnItems (copy), AvatarScreen (copy), CloseAllItemDetails (copy), CatalogUtils (copy), FFlagUseNavigationSelectors (copy), Selectors (copy), ToggleTryOn (copy), p5 (copy), p8 (copy), FFlagAXDurablesForMIS (copy), n1 (copy)
		local v56 = p9:getState()

		if v56.AvatarExperience.LayeredClothingSort.CharacterUpdatesLocked then
			return
		end

		if not p4 then
			return
		end

		local v57 = nil
		local v58 = nil
		local v59 = nil

		if p3 == Constants.ItemType.Bundle then
			v57 = Utils.getOutfitInfoFromBundleId(v56, s1)

			local v60 = v56.AvatarExperience.Common.BundleInfos[s1]

			v58 = if not v60 then nil else v60.isRecolorable
			v59 = if not v58 or not v60 then nil else p4 == Constants.BundleTypeIdStrings.BodyParts

			if not v57 then
				p9:dispatch(FetchOutfitInfoFromBundle(p1, s1))
			end
		end

		local TryOnItems = p9:getState().AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
		local v62 = getTryOnItemReducerKey(s1, p3)
		local v63 = TryOnItems[v62]

		if b1 and v63 ~= nil then
			return
		end

		if FFlagAXEnableExpiredUserLookCheckout and p7 then
			NavigationUtils.closeExpiredUserLookActionBar(p7)
		end

		local v64 = p6 and AvatarScreenProperties[p6.opaque.name].isMultiTryOn

		if not FFlagAXMISEnableMultiShopping and not v64 then
			if not v63 then
				p9:dispatch(ClearTryOns(v59))

				if FFlagAXMigrateAXToGlobalAutofocus and p7 then
					NavigationUtils.closeTryOnManager(p7)
				end
			elseif p7 then
				NavigationUtils.closeFiltersAndItemDetails(p7)
			end
		end

		if v36 and FFlagAXMISEnableMultiShopping and p7 and v63 then
			NavigationUtils.closeFiltersAndItemDetails(p7)
		end

		p9:dispatch(FetchAssetOrBundleInfo(p1, p2, s1, p3))

		if Utils.isBundleOrLCAsset(p3, p4) then
			p9:dispatch(StartedWaitingOnLCUpdate())
		end

		local v65, v66 = SelectOrderedToggledOnItemsList(v56)
		local v67 = if not FFlagAXCatalogMakeupSupport then nil else SelectOrderedToggledOnMakeupItemsList(v56)
		local v68 = if not FFlagAXCatalogMakeupSupport or not isMakeupAssetType(p4) then SelectUpdatedSortOrderForToggledOnItems(v56, s1, p3, p4, v65, v66) else SelectUpdatedSortOrderForToggledOnMakeupItems(v56, s1, p3, p4, v67)

		if v68.equippedAssetsToSetOrder then
			p9:dispatch(SetOrder(v68.equippedAssetsToSetOrder))
		end

		if v68.itemIdToOrderMap then
			p9:dispatch(SetOrderForTryOns(v68.itemIdToOrderMap))
		end

		if p4 == Constants.AssetTypeIdStrings.Face then
			local EquippedAssets = v56.AvatarExperience.AvatarEditor.Character.EquippedAssets

			if not v56.AvatarExperience.AvatarScene.OutfitTryOn.LastTryOnClassicHeadShape and not Utils2.isClassicHeadEquipped(EquippedAssets) then
				local HeadRefinement = v56.AvatarExperience.AvatarScene.HeadRefinement
				local v71 = HeadRefinement and HeadRefinement.lastSelectedHeadShape or HeadShape.Default

				p9:dispatch(TryOnClassicHeadShape(v71))
			end
		else
			p9:dispatch(TryOnClassicHeadShape(nil))
		end

		local items = nil

		if FFlagAXMISEnableMultiShopping and p3 == Constants.ItemType.Bundle then
			local v73 = v56.AvatarExperience.Common.BundleInfos[s1]

			if v73 then
				items = v73.items
			end
		end

		if FFlagAXMISEnableMultiShopping then
			local v74 = TryOnItems[v62] ~= nil
			local v75 = useMultiItemShoppingFtux()

			if v75.shouldShowItemReplacedOnAvatarPrompt() and not b2 and tutils.fieldCount(TryOnItems) > 1 and not v74 and p4 then
				local t1 = nil

				if items ~= nil then
					t1 = {}

					for _, v78 in items do
						if v78.type == Constants.ItemType.Asset and v78.assetType then
							t1[v78.id] = {
								assetType = v78.assetType
							}
						end
					end
				end

				local _, v80 = getFilteredTryOnItems(TryOnItems, {
					itemType = p3,
					itemSubType = p4,
					bundleInfo = t1
				})
				local _, v82 = next(v80)

				if v82 and p7 then
					p7.navigate(AvatarScreen.ItemReplacedOnAvatarPrompt, {
						onConfirm = function() -- line: 255
							-- upvalues: v75 (copy), p9 (copy), CloseAllItemDetails (copy), p7 (copy)
							v75.setSeenItemReplaceOnAvatarPrompt()
							p9:dispatch(CloseAllItemDetails(p7))
						end,
						beforeItem = {
							itemId = v82.itemId,
							thumbType = CatalogUtils.GetRbxThumbType(v82.itemType)
						},
						afterItem = {
							itemId = s1,
							thumbType = CatalogUtils.GetRbxThumbType(p3)
						}
					})
				end
			end
		end

		if FFlagAXMISEnableMultiShopping and p7 and ((if not FFlagUseNavigationSelectors then v56.Navigation.currentRoute else Selectors.selectCurrentRoactNavigationRoute(v56))).routeName == AvatarScreen.Checkout then
			NavigationUtils.closeFocusedScreen(p7)
		end

		p9:dispatch(ToggleTryOn(p3, p4, s1, p5, v68.overrideOrder, v68.bundleInfoMapping, p8, not not v57, v58, if not FFlagAXMISEnableMultiShopping then nil else items, if not FFlagAXMISEnableMultiShopping then nil else b2, if not FFlagAXDurablesForMIS then nil else n1))
	end
end
