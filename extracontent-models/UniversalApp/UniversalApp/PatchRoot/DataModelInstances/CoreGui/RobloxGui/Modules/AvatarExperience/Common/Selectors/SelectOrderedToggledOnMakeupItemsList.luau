local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)

require(Modules.AvatarExperience.Common.AvatarExperienceState)
require(Modules.AvatarExperience.Common.Types)

local ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = AvatarExperienceCommon.Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE
local LAYERED_MAKEUP_ORDER = AvatarExperienceCommon.Constants.LAYERED_MAKEUP_ORDER
local v9 = memoize(function(p1, p2) -- line: 24
	-- upvalues: Constants (copy), ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE (copy), LAYERED_MAKEUP_ORDER (copy)
	local t1 = {}
	local t2 = {}

	if p2 ~= nil then
		for _, v15 in p2 do
			if v15.itemType == Constants.ItemType.Asset then
				local itemSubType = v15.itemSubType

				if ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[itemSubType] then
					t2[v15.itemId] = v15.order or LAYERED_MAKEUP_ORDER[itemSubType]
					table.insert(t1, {
						id = v15.itemId,
						typeId = itemSubType
					})
				end
			elseif v15.bundleInfo then
				for v17, v18 in v15.bundleInfo do
					local assetType = v18.assetType

					if ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[assetType] then
						t2[v17] = v18.order or LAYERED_MAKEUP_ORDER[assetType]
						table.insert(t1, {
							id = v17,
							typeId = assetType
						})
					end
				end
			end
		end
	end

	if p1 ~= nil then
		for v20, v21 in p1 do
			for v22, v23 in v21 do
				if LAYERED_MAKEUP_ORDER[v20] then
					t2[v22] = v23.order or LAYERED_MAKEUP_ORDER[v20]
					table.insert(t1, {
						id = v22,
						typeId = v20
					})
				end
			end
		end
	end

	table.sort(t1, function(p3, p4) -- line: 75
		-- upvalues: t2 (copy)
		return t2[p3.id] > t2[p4.id]
	end)

	return t1
end)

return function(p5) -- line: 83
	-- upvalues: v9 (copy)
	local EquippedAssets = p5.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local TryOnItems = p5.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

	return v9(EquippedAssets, TryOnItems)
end
