local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local Modules = CoreGui.RobloxGui.Modules
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local LayeredMakeupSortUtils = require(Modules.AvatarExperience.LayeredMakeupSort.LayeredMakeupSortUtils)

require(Modules.AvatarExperience.Common.AvatarExperienceState)
require(Modules.AvatarExperience.Common.Types)
require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

local ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = AvatarExperienceCommon.Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE

local function _separateSortedAssets(p1, _, p3, p4, _) -- line: 26
	if p1[p3.typeId] and p1[p3.typeId][p3.id] then
		p4[p3.id] = {
			assetTypeId = p3.typeId,
			order = p3.order
		}
	end
end
local function v10(s1: string, p6, s2: string?, t1: {[any]: any}, _, _, _) -- line: 35
	-- upvalues: Constants (copy), ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE (copy), LayeredMakeupSortUtils (copy)
	local v23 = nil

	if p6 ~= Constants.ItemType.Bundle and s2 and ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[s2] then
		local v24

		v24, v23 = LayeredMakeupSortUtils.getTableAndOrderAfterEquippingIntoSort(t1, {
			id = s1,
			typeId = s2
		})
	end

	return {
		overrideOrder = v23,
		bundleInfoMapping = {},
		equippedAssetsToSetOrder = {},
		itemIdToOrderMap = {}
	}
end

return function(p10, s3: string, p11, s4: string?, t2: {[any]: any}) -- line: 112
	-- upvalues: Utils (copy), v10 (copy)
	local EquippedAssets = p10.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local AssetInfos = p10.AvatarExperience.Common.AssetInfos
	local v32 = Utils.getBundleInfoFromState(p10, s3)

	return (v10(s3, p11, s4, t2, EquippedAssets, AssetInfos, v32))
end
