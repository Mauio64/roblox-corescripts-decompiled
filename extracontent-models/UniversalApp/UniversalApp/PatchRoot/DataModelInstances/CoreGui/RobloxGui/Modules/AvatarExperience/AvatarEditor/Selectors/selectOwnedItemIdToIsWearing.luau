local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)
local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Utils2 = require(Modules.AvatarExperience.Common.Utils)

require(Modules.AvatarExperience.Common.Types)

local GetFFlagEnableNewCustomizeBundleEquip = require(Modules.AvatarExperience.Flags.GetFFlagEnableNewCustomizeBundleEquip)
local GetFFlagAXEnableNewInventoryItemsList = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableNewInventoryItemsList)
local FFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters

require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local function isWearingAssetOrOutfit(p1, p2, p3, p4, p5, p6, p7, p8, _) -- line: 40
	-- upvalues: Constants (copy), Utils (copy), GetFFlagEnableNewCustomizeBundleEquip (copy)
	local selectedSlot = p8.selectedSlot
	local v27 = p8.slotInfo[selectedSlot]
	local v28 = p2.RenderOutfitItemTiles == true

	if p2.PageType == Constants.PageType.Emotes then
		if v27 then
			return p1 == v27.assetId
		end

		return false
	end

	if not p3 then
		return false
	end

	if v28 and p7[p1] then
		local v29 = p7[p1]

		return Utils.isWearingOutfitNoState(v29, p6, p4, p3, p5, not not GetFFlagEnableNewCustomizeBundleEquip() or nil)
	end

	for _, v31 in p3 do
		if v31[p1] then
			return true
		end
	end

	return false
end

local v15 = memoize(function(p10, p11, p12, p13, p14, p15, p16, p17, p18, p19) -- line: 91
	-- upvalues: Constants2 (copy), Cryo (copy), isWearingAssetOrOutfit (copy), GetFFlagAXEnableNewInventoryItemsList (copy)
	local t1 = {}
	local v43 = false

	if not p10 then
		return t1, v43
	end

	local v44 = p12[p10]

	if p10 == Constants2.EditableCharacterKey or p10 == Constants2.PurchasedCharacterKey then
		local v45 = p12[Constants2.PurchasedCharacterKey] or {}

		v44 = Cryo.List.join(v45, p12[Constants2.EditableCharacterKey] or {})
	end

	if not v44 then
		return t1, v43
	end

	for _, v47 in v44 do
		local v48 = isWearingAssetOrOutfit(v47, p11, p13, p14, p15, p16, p17, p18, p19)

		t1[v47] = v48

		if v48 then
			v43 = v48
		end
	end

	if GetFFlagAXEnableNewInventoryItemsList() and p13 or not GetFFlagAXEnableNewInventoryItemsList() and p11.Sort then
		for _, v50 in p11.AssetTypeIdStrings or {} do
			for v51, v52 in p13 do
				for v53, _ in v52 do
					if v50 == v51 then
						t1[v53] = true
						v43 = true
					end
				end
			end
		end
	end

	return t1, v43
end)

local function selectOwnedItemIdToIsWearing(p20, p21) -- line: 177
	-- upvalues: Utils2 (copy), FFlagAXEditorSubcategoryFilters (copy), v15 (copy)
	local v57 = Utils2.getAvatarEditorCategoryInfoFromState(p20)
	local v58 = if not FFlagAXEditorSubcategoryFilters then nil else Utils2.getAvatarEditorSubcategoryFilterFromState(p20)
	local v59 = FFlagAXEditorSubcategoryFilters and v58 or v57

	return v15(p21, if not FFlagAXEditorSubcategoryFilters then v57 else v59, p20.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype, p20.AvatarExperience.AvatarEditor.Character.EquippedAssets, p20.AvatarExperience.AvatarEditor.Character.BodyColor3s, p20.AvatarExperience.AvatarEditor.Character.AvatarScales, p20.AvatarExperience.AvatarEditor.Character.AvatarType, p20.AvatarExperience.AvatarEditor.OutfitInfos, p20.AvatarExperience.AvatarEditor.EquippedEmotes, p20.AvatarExperience.AvatarEditor.Character.OutfitOrAsset)
end

return selectOwnedItemIdToIsWearing
