local isMakeupAssetType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Utils/isMakeupAssetType")
local selectTryOnItems = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/State/Selectors/selectTryOnItems")

local function selectHasMakeupTryOn(p2): boolean
	for k, v5 in selectTryOnItems(p2) do
		if v5.selectedInTryOnManager and v5.itemType and isMakeupAssetType(v5.itemSubType) then
			return true
		end
	end

	return false
end

return selectHasMakeupTryOn
