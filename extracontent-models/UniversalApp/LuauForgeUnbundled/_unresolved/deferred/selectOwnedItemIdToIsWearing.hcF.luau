local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local module2 = require("@luauforge/bundled/dPN")
local module3 = require("@luauforge/bundled/fCI")
local module4 = require("@luauforge/bundled/dRg")
local module5 = require("@luauforge/bundled/fCe")
require("@luauforge/bundled/dPs")

local module6 = require("@luauforge/bundled/dSb")

local module7 = require("@luauforge/bundled/dRr")
local fFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters
local fFlagAXBackgroundsOutfitHighlight = AvatarExperienceFlags.FFlagAXBackgroundsOutfitHighlight
require("@luauforge/bundled/dKU")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local fFlagAXMigrateOutfitsToUserInventory = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMigrateOutfitsToUserInventory

local avatarEditorCategories = require("@luauforge/bundled/dPt").Enums.AvatarEditorCategories

local function isWearingAssetOrOutfit(p2, p3, items, p4, p5, p6, p7, p8, p9, p10)
	local selectedSlot = p8.selectedSlot
	local v5 = p8.slotInfo[selectedSlot]
	local renderOutfitItemTiles = p3.RenderOutfitItemTiles == true

	if p3.PageType == module2.PageType.Emotes then
		if v5 then
			return v5.assetId == p2
		end
	else
		if not items then
			return false
		end

		if renderOutfitItemTiles and p7[p2] then
			local v6 = p7[p2]
			return module3.isWearingOutfitNoState(
				v6,
				p6,
				p4,
				items,
				p5,
				module6() and true or nil,
				nil,
				p10
			)
		end

		for k, item in items do
			if item[p2] then
				return true
			end
		end
	end

	return false
end

local v5 = memoize(function(p2, p3, p4, items, p5, p6, p7, p8, p9, p10, p11)
	local result = {}
	local v6 = false

	if not p2 then
		return result, false
	end

	local v7 = p4[p2]
	local v8

	if fFlagAXMigrateOutfitsToUserInventory then
		v8 = avatarEditorCategories.Avatars
	else
		v8 = module4.EditableCharacterKey
	end

	if p2 == v8 or p2 == module4.PurchasedCharacterKey then
		local v9 = p4[module4.PurchasedCharacterKey] or {}
		local join = Cryo.List.join
		local v10

		if fFlagAXMigrateOutfitsToUserInventory then
			v10 = avatarEditorCategories.Avatars
		else
			v10 = module4.EditableCharacterKey
		end

		v7 = join(v9, p4[v10] or {})
	end

	if not v7 then
		return result, v6
	end

	for k, v9 in v7 do
		local wearingAssetOrOutfit = isWearingAssetOrOutfit(v9, p3, items, p5, p6, p7, p8, p9, p10, p11)

		result[v9] = wearingAssetOrOutfit

		if wearingAssetOrOutfit then
			v6 = wearingAssetOrOutfit
		end
	end

	if module7() and items or not module7() and p3.Sort then
		for k, v9 in p3.AssetTypeIdStrings or {} do
			for k2, item in items do
				for k3, v10 in item do
					if v9 ~= k2 then
						continue
					end

					result[k3] = true
					v6 = true
				end
			end
		end
	end

	return result, v6
end)

local function selectOwnedItemIdToIsWearing(p2, p3)
	local v6 = module5.getAvatarEditorCategoryInfoFromState(p2)
	local v7

	if fFlagAXEditorSubcategoryFilters then
		v7 = module5.getAvatarEditorSubcategoryFilterFromState(p2)
	end

	local v8 = if fFlagAXEditorSubcategoryFilters then v7 or v6 else v6

	if fFlagAXEditorSubcategoryFilters then
		v6 = v8
	end

	local ownedItemIdsBySubtype = p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
	local equippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local bodyColor3s = p2.AvatarExperience.AvatarEditor.Character.BodyColor3s
	local avatarScales = p2.AvatarExperience.AvatarEditor.Character.AvatarScales
	local avatarType = p2.AvatarExperience.AvatarEditor.Character.AvatarType
	local outfitInfos = p2.AvatarExperience.AvatarEditor.OutfitInfos
	local equippedEmotes = p2.AvatarExperience.AvatarEditor.EquippedEmotes
	local outfitOrAsset = p2.AvatarExperience.AvatarEditor.Character.OutfitOrAsset

	local v10 = if fFlagAXBackgroundsOutfitHighlight then AvatarExperienceCommon.Backgrounds.selectActiveBackground(p2) else nil
	return v5(
		p3,
		v6,
		ownedItemIdsBySubtype,
		equippedAssets,
		bodyColor3s,
		avatarScales,
		avatarType,
		outfitInfos,
		equippedEmotes,
		outfitOrAsset,
		v10
	)
end

return selectOwnedItemIdToIsWearing
