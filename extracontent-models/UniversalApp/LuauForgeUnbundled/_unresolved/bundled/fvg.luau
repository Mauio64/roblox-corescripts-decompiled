local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local tutils = require(CorePackages.Packages.tutils)
require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local module = require("@luauforge/bundled/dHL")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local fFlagAXUseSignalsForLayeredClothingCurrentSort = AvatarExperienceFlags.FFlagAXUseSignalsForLayeredClothingCurrentSort
local getLayeredClothingCurrentSortStore

if fFlagAXUseSignalsForLayeredClothingCurrentSort then
	getLayeredClothingCurrentSortStore = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Stores.getLayeredClothingCurrentSortStore
else
	getLayeredClothingCurrentSortStore = nil
end

local fFlagAXRemoveUnusedCharacterUpdatesLockedRoduxSlice = AvatarExperienceFlags.FFlagAXRemoveUnusedCharacterUpdatesLockedRoduxSlice

local module3 = require("@luauforge/bundled/dOy")
local clearTryOns = module.Actions.ClearTryOns
local module4 = require("@luauforge/bundled/dMx")
local module5 = require("@luauforge/bundled/dNQ")
local module6 = require("@luauforge/bundled/dCh")
local module7 = require("@luauforge/bundled/dTC")
local module8 = require("@luauforge/bundled/dLU")
local module9 = require("@luauforge/bundled/dwB")
local module10 = require("@luauforge/bundled/dTM")
require("@luauforge/bundled/dMc")
local module11 = require("@luauforge/bundled/fvh")
local toggleTryOn = module.Actions.ToggleTryOn

local maxHats = module5.MaxHats

local v5 = {
	toastMessage = "Feature.Avatar.Message.HatLimitTooltip",
	isLocalized = false,
	toastType = module9.InformationMessage
}

local v6 = {
	toastMessage = "Feature.Avatar.EmoteAlreadyAssigned",
	isLocalized = false,
	toastType = module9.InformationMessage
}

return function(p2, p3, p4, p5, p6, p7, items)
	return function(object): boolean
		local equippedAssets = object:getState().AvatarExperience.AvatarEditor.Character.EquippedAssets

		if not equippedAssets then
			return false
		end

		local v7

		if fFlagAXRemoveUnusedCharacterUpdatesLockedRoduxSlice then
			v7 = false
		else
			v7 = object:getState().AvatarExperience.LayeredClothingSort.CharacterUpdatesLocked
		end

		if v7 then
			return false
		end

		if p5 then
			object:dispatch(toggleTryOn(module4.ItemType.Asset, p2, p3, false))

			if p4 then
				module10.closeFiltersAndItemDetails(p4)
			end
		else
			local tryOnItems = object:getState().AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

			if not Cryo.isEmpty(tryOnItems) then
				object:dispatch(clearTryOns())

				if p4 then
					module10.closeFiltersAndItemDetails(p4)
				end
			end
		end

		if p2 == module4.AssetTypeIdStrings.EmoteAnimation then
			local equippedEmotes = object:getState().AvatarExperience.AvatarEditor.EquippedEmotes
			local v8 = equippedEmotes.slotInfo[equippedEmotes.selectedSlot]

			if not v8 or v8.assetId ~= p3 then
				for k, v9 in equippedEmotes.slotInfo do
					if v9.assetId == p3 then
						object:dispatch(module6(v6))

						return false
					end
				end
			end
		end

		local equippedAsset = equippedAssets[module4.AssetTypeIdStrings.Hat]

		local v8 = not equippedAsset and 0 or tutils.fieldCount(equippedAsset)

		if
			p2 == module4.AssetTypeIdStrings.Hat
			and equippedAsset
			and maxHats <= v8
			and not (equippedAsset or {})[p3]
		then
			object:dispatch(module6(v5))
			return false
		end

		local state = object:getState()

		if fFlagAXUseSignalsForLayeredClothingCurrentSort then
			if #getLayeredClothingCurrentSortStore(false).getOrderedList(false) ~= 0 then
				getLayeredClothingCurrentSortStore(false).clearCurrentSort()
			end
		elseif #state.AvatarExperience.LayeredClothingSort.CurrentSort.OrderedList ~= 0 then
			object:dispatch(module7())
		end

		if module4.LayeredAssetTypes[p2] ~= nil then
			object:dispatch(module8())
		end

		local dynamicHeadEquipped = module11.isDynamicHeadEquipped(equippedAssets)

		if p2 == module4.AssetTypeIdStrings.Face and dynamicHeadEquipped then
			for k, dynamicHeadAssetType in module4.DynamicHeadAssetTypes do
				local equippedAssetIdsForType = module11.getEquippedAssetIdsForType(equippedAssets, k)

				for k2, v9 in equippedAssetIdsForType do
					object:dispatch(module3(k, v9))
				end
			end
		end

		if items then
			for k, item in items do
				if not equippedAssets[item] then
					continue
				end

				for k2, v9 in equippedAssets[item] do
					if v9.order == p6 then
						object:dispatch(module3(item, k2))
					end
				end
			end
		end

		object:dispatch(module3(p2, p3, p6, p7))

		return true
	end
end
