local isMakeupAssetType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/isMakeupAssetType")
local selectTryOnItems = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectTryOnItems")
local selectEquippedLayeredMakeupAssets = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectEquippedLayeredMakeupAssets")

local function selectTotalLayeredMakeupAssets(p2)
	local v5 = #selectEquippedLayeredMakeupAssets(p2)
	local count = 0

	for k, v6 in selectTryOnItems(p2) do
		if v6.selectedInTryOnManager and v6.itemType and isMakeupAssetType(v6.itemSubType) then
			count += 1
		end
	end

	return v5 + count
end

return selectTotalLayeredMakeupAssets
