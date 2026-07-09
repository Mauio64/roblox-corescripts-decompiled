local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local Modules = CoreGui.RobloxGui.Modules
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local LayeredClothingSortUtils = require(Modules.AvatarExperience.LayeredClothingSort.LayeredClothingSortUtils)

require(Modules.AvatarExperience.Common.AvatarExperienceState)
require(Modules.AvatarExperience.Common.Types)
require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local function separateSortedAssets(p1, p2, p3, p4, p5, p6) -- line: 34
	if p1[p3.typeId] and p1[p3.typeId][p3.id] then
		p4[p3.id] = {
			assetTypeId = p3.typeId,
			order = #p2 - p6
		}

		return
	end

	p5[p3.id] = #p2 - p6
end

local v9 = memoize(function(s1: string, p7, s2: string?, t1: {[any]: any}, b1: boolean, p8, p9, p10) -- line: 53
	-- upvalues: Constants (copy), LayeredClothingSortUtils (copy), separateSortedAssets (copy)
	local t2 = {}
	local v25 = nil
	local t3 = {}
	local t4 = {}

	if p7 == Constants.ItemType.Bundle then
		if p8 and p8.items then
			assert(p8, "silence type checker")
			assert(p8.items, "silence type checker")

			for _, v29 in p8.items do
				local v30 = p10[v29.id] and p10[v29.id].assetType

				if v30 then
					local v31 = Constants.LayeredAssetTypes[v30] ~= nil

					if not b1 and not Constants.LCIgnoredForSorting[v30] and v31 then
						t1, v25 = LayeredClothingSortUtils.getTableAndOrderAfterEquippingIntoSort(t1, {
							id = v29.id,
							typeId = v30
						})
					end

					t2[tostring(v29.id)] = {
						assetType = v30,
						order = v25 or Constants.LayeredClothingOrder[v30]
					}
				end
			end

			for k, v in pairs(t1) do
				if t2[v.id] == nil then
					separateSortedAssets(p9, t1, v, t3, t4, k)
				end
			end
		end
	else
		local v34 = Constants.LayeredAssetTypes[s2] ~= nil

		if not b1 and not Constants.LCIgnoredForSorting[s2] and v34 then
			local v35

			v35, v25 = LayeredClothingSortUtils.getTableAndOrderAfterEquippingIntoSort(t1, {
				id = s1,
				typeId = s2
			})

			for v36, v37 in v35 do
				if s1 ~= v37.id then
					separateSortedAssets(p9, v35, v37, t3, t4, v36)
				end
			end
		end
	end

	return {
		overrideOrder = v25,
		bundleInfoMapping = t2,
		equippedAssetsToSetOrder = t3,
		itemIdToOrderMap = t4
	}
end)

return function(p11, s3: string, p12, s4: string?, t5: {[any]: any}, b2: boolean) -- line: 153
	-- upvalues: Utils (copy), v9 (copy)
	local EquippedAssets = p11.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local AssetInfos = p11.AvatarExperience.Common.AssetInfos
	local v46 = Utils.getBundleInfoFromState(p11, s3)

	return v9(s3, p12, s4, t5, b2, v46, EquippedAssets, AssetInfos)
end
