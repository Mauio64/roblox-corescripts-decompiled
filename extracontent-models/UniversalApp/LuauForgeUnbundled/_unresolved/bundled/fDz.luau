local CorePackages = game:GetService("CorePackages")

local tutils = require(CorePackages.Packages.tutils)
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module4 = require("@luauforge/bundled/dKU")
local getFilteredTryOnItems = AvatarExperienceCommon.Utils.getFilteredTryOnItems
local useMultiItemShoppingFtux = AvatarExperienceCatalog.Hooks.useMultiItemShoppingFtux

local module5 = require("@luauforge/bundled/dVl")
local module6 = require("@luauforge/bundled/fDA")
local module7 = require("@luauforge/bundled/dPN")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors
local module8 = require("@luauforge/bundled/fCe")
local module9 = require("@luauforge/bundled/dXh")
local module10 = require("@luauforge/bundled/dPk")
local toggleTryOn = module4.Actions.ToggleTryOn
local module11 = require("@luauforge/bundled/fCE")
local setOrderForTryOns = module4.Actions.SetOrderForTryOns
local module12 = require("@luauforge/bundled/dRZ")

local module13 = require("@luauforge/bundled/fDE")

local module14 = require("@luauforge/bundled/fDK")

local module15 = require("@luauforge/bundled/fDF")

local module16 = require("@luauforge/bundled/fDL")
local module17 = require("@luauforge/bundled/fCI")
local module18 = require("@luauforge/bundled/fCd")

local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey
local isMakeupAssetType = AvatarExperienceCommon.Utils.isMakeupAssetType

require("@luauforge/bundled/dPs")

local headShape = require("@luauforge/bundled/dPt").Enums.HeadShape
local tryOnClassicHeadShape = module4.Actions.TryOnClassicHeadShape

local fFlagAXDurablesForMIS = AvatarExperienceFlags.FFlagAXDurablesForMIS
local fFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors

local fFlagSignalsNavP3gAvatarExperience = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3gAvatarExperience
local getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
local fFlagAXEnableExpiredUserLookCheckout = AvatarExperienceFlags.FFlagAXEnableExpiredUserLookCheckout

local fFlagAXRemoveUnusedCharacterUpdatesLockedRoduxSlice = AvatarExperienceFlags.FFlagAXRemoveUnusedCharacterUpdatesLockedRoduxSlice

return function(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13)
	return function(object)
		local state = object:getState()
		local v5

		if fFlagSignalsNavP3gAvatarExperience then
			v5 = getLegacyNavigationStore(false).getCurrentRoute(false)
		end

		local v6

		if fFlagAXRemoveUnusedCharacterUpdatesLockedRoduxSlice then
			v6 = false
		else
			v6 = state.AvatarExperience.LayeredClothingSort.CharacterUpdatesLocked
		end

		if v6 or not p5 then
			return
		end

		local v7, isRecolorable

		if p4 == module7.ItemType.Bundle then
			v7 = module8.getOutfitInfoFromBundleId(state, p6)

			local bundleInfo = state.AvatarExperience.Common.BundleInfos[p6]

			if bundleInfo then
				isRecolorable = bundleInfo.isRecolorable
			end

			if not v7 then
				object:dispatch(module6(p2, p6))
			end
		end

		local tryOnItems = object:getState().AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
		local tryOnItemReducerKey = getTryOnItemReducerKey(p6, p4)
		local tryOnItem = tryOnItems[tryOnItemReducerKey]

		if p11 and tryOnItem ~= nil then
			return
		end

		if fFlagAXEnableExpiredUserLookCheckout and p9 then
			module9.closeExpiredUserLookActionBar(p9)
		end

		if p9 and tryOnItem then
			module9.closeFiltersAndItemDetails(p9)
		end

		object:dispatch(module18(p2, p3, p6, p4))

		if module8.isBundleOrLCAsset(p4, p5) then
			object:dispatch(module10())
		end

		local v8, v9 = module13(state)

		local v10 = if fFlagAXCatalogMakeupSupport then module14(state) else nil
		local v11

		if fFlagAXCatalogMakeupSupport and isMakeupAssetType(p5) then
			v11 = module16(state, p6, p4, p5, v10)
		else
			v11 = module15(state, p6, p4, p5, v8, v9)
		end

		if v11.equippedAssetsToSetOrder then
			object:dispatch(module12(v11.equippedAssetsToSetOrder))
		end

		if v11.itemIdToOrderMap then
			object:dispatch(setOrderForTryOns(v11.itemIdToOrderMap))
		end

		if p5 == module7.AssetTypeIdStrings.Face then
			local equippedAssets = state.AvatarExperience.AvatarEditor.Character.EquippedAssets

			if not (state.AvatarExperience.AvatarScene.OutfitTryOn.LastTryOnClassicHeadShape or module17.isClassicHeadEquipped(equippedAssets)) then
				local headRefinement = state.AvatarExperience.AvatarScene.HeadRefinement
				local lastSelectedHeadShape = headRefinement and headRefinement.lastSelectedHeadShape
					or headShape.Default
				object:dispatch(tryOnClassicHeadShape(lastSelectedHeadShape))
			end
		else
			object:dispatch(tryOnClassicHeadShape(nil))
		end

		local items = nil

		if p4 == module7.ItemType.Bundle then
			local bundleInfo = state.AvatarExperience.Common.BundleInfos[p6]

			if bundleInfo then
				items = bundleInfo.items
			end
		end

		local v13 = tryOnItems[tryOnItemReducerKey] ~= nil
		local v14 = useMultiItemShoppingFtux()

		if
			v14.shouldShowItemReplacedOnAvatarPrompt()
			and not p12
			and tutils.fieldCount(tryOnItems) > 1
			and not v13
			and p5
		then
			local v15

			if items ~= nil then
				v15 = {}

				for k, item in items do
					if item.type == module7.ItemType.Asset and item.assetType then
						v15[item.id] = { assetType = item.assetType }
					end
				end
			end

			local filteredTryOnItems, v16 = getFilteredTryOnItems(tryOnItems, {
				itemType = p4,
				itemSubType = p5,
				bundleInfo = v15
			})

			local v17, v18 = next(v16)

			if v18 and p9 then
				p9.navigate(avatarScreen.ItemReplacedOnAvatarPrompt, {
					onConfirm = function()
						v14.setSeenItemReplaceOnAvatarPrompt()
						object:dispatch(module11(p9))
					end,
					beforeItem = {
						itemId = v18.itemId,
						thumbType = module5.GetRbxThumbType(v18.itemType)
					},
					afterItem = { itemId = p6, thumbType = module5.GetRbxThumbType(p4) }
				})
			end
		end

		if p9 then
			if not fFlagSignalsNavP3gAvatarExperience then
				if fFlagUseNavigationSelectors then
					v5 = selectors.selectCurrentRoactNavigationRoute(state)
				else
					v5 = state.Navigation.currentRoute
				end
			end

			if v5.routeName == avatarScreen.Checkout then
				module9.closeFocusedScreen(p9)
			end
		end

		object:dispatch(toggleTryOn(
			p4,
			p5,
			p6,
			p7,
			v11.overrideOrder,
			v11.bundleInfoMapping,
			p10,
			v7 and true or false,
			isRecolorable,
			items,
			p12,
			if fFlagAXDurablesForMIS then p13 else nil
		))
	end
end
