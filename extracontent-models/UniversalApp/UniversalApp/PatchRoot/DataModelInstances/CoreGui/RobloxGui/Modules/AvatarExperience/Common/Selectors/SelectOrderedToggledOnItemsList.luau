local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)

require(Modules.AvatarExperience.Common.AvatarExperienceState)
require(Modules.AvatarExperience.Common.Types)

local ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = AvatarExperienceCommon.Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local v10 = memoize(function(p1, p2) -- line: 25
	-- upvalues: Constants (copy), FFlagAXCustomizeMakeupSupport (copy), ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE (copy)
	local t1 = {}
	local t2 = {}
	local t3 = {}
	local v16 = true

	if not p1 or not p2 then
		return {}, v16
	end

	for _, v18 in p2 do
		if v18.itemType == Constants.ItemType.Asset then
			local itemSubType = v18.itemSubType

			if not Constants.LCIgnoredForSorting[itemSubType] and v18.isLayered and (not FFlagAXCustomizeMakeupSupport or not ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[itemSubType]) then
				t3[itemSubType] = true
				t2[v18.itemId] = v18.order or Constants.LayeredClothingOrder[itemSubType]

				if v18.order and v18.order ~= Constants.LayeredClothingOrder[itemSubType] then
					v16 = false
				end

				table.insert(t1, {
					id = v18.itemId,
					typeId = itemSubType
				})
			end
		elseif v18.bundleInfo then
			for v20, v21 in v18.bundleInfo do
				local assetType = v21.assetType
				local v23 = Constants.LayeredAssetTypes[assetType] ~= nil

				if not Constants.LCIgnoredForSorting[assetType] and v23 and (not FFlagAXCustomizeMakeupSupport or not ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[assetType]) then
					t3[assetType] = true
					t2[v20] = v21.order or Constants.LayeredClothingOrder[assetType]

					if v21.order and v21.order ~= Constants.LayeredClothingOrder[assetType] then
						v16 = false
					end

					table.insert(t1, {
						id = v20,
						typeId = assetType
					})
				end
			end
		end
	end

	for v24, v25 in p1 do
		for v26, v27 in v25 do
			if not t3[v24] and not Constants.LCIgnoredForSorting[v24] and v27.isLayered and (not FFlagAXCustomizeMakeupSupport or not ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[v24]) then
				t2[v26] = v27.order or Constants.LayeredClothingOrder[v24]

				if v27.order and v27.order ~= Constants.LayeredClothingOrder[v24] then
					v16 = false
				end

				table.insert(t1, {
					id = v26,
					typeId = v24
				})
			end
		end
	end

	if v16 then
		return {}, v16
	end

	table.sort(t1, function(p3, p4) -- line: 125
		-- upvalues: t2 (copy)
		return t2[p3.id] > t2[p4.id]
	end)

	return t1, v16
end)

return function(p5) -- line: 134
	-- upvalues: v10 (copy)
	local EquippedAssets = p5.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local TryOnItems = p5.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

	return v10(EquippedAssets, TryOnItems)
end
