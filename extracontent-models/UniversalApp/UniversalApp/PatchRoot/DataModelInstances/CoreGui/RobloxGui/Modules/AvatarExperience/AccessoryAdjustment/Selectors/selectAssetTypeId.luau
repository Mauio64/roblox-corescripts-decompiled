local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize

require(Modules.AvatarExperience.Common.Reducers.OutfitTryOn)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local FFlagAXRemoveMemoizeFromAccessoryAdjustmentUtils = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRemoveMemoizeFromAccessoryAdjustmentUtils

local function v6(p1, p2) -- line: 16
	for v11, v12 in p1 do
		for v13, _ in v12 do
			if p2 == v13 then
				return v11
			end
		end
	end

	return nil
end
local function v7(p3, p4, p5, p6) -- line: 28
	for _, v20 in p3 do
		if v20.itemType == "Asset" and p6 == v20.itemId then
			return v20.itemSubType
		end

		if v20.itemType == "Bundle" then
			local v21 = p4[v20.itemId]

			if v21 then
				local items = v21.items

				if items ~= nil then
					for _, v24 in items do
						if v24.type ~= "Asset" or p6 ~= v24.id then
							continue
						end

						local v25 = p5[v24.id]

						if v25 and v25.assetType then
							return v25.assetType
						end
					end
				end
			end
		end
	end

	return nil
end

local v8 = memoize(function(p7, p8, p9, p10, p11) -- line: 53
	-- upvalues: v7 (copy), v6 (copy)
	local v31 = v7(p7, p9, p10, p11)

	if v31 then
		return v31
	end

	local v32 = v6(p8, p11)

	if v32 then
		return v32
	end

	return nil
end)

return function(p12) -- line: 70
	-- upvalues: FFlagAXRemoveMemoizeFromAccessoryAdjustmentUtils (copy), v7 (copy), v6 (copy), v8 (copy)
	local TryOnItems = p12.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	local BundleInfos = p12.AvatarExperience.Common.BundleInfos
	local AssetInfos = p12.AvatarExperience.Common.AssetInfos
	local EquippedAssets = p12.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local SelectedAccessory = p12.AvatarExperience.AccessoryAdjustment.SelectedAccessory

	if FFlagAXRemoveMemoizeFromAccessoryAdjustmentUtils then
		local v39 = v7(TryOnItems, BundleInfos, AssetInfos, SelectedAccessory)

		if v39 then
			return v39
		end

		local v40 = v6(EquippedAssets, SelectedAccessory)

		if v40 then
			return v40
		end

		return nil
	end

	return v8(TryOnItems, EquippedAssets, BundleInfos, AssetInfos, SelectedAccessory)
end
