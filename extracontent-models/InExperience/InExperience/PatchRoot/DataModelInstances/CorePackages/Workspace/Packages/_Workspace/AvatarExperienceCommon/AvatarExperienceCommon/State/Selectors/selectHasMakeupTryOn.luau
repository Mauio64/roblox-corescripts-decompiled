local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local isMakeupAssetType = require(AvatarExperienceCommon.Utils.isMakeupAssetType)
local selectTryOnItems = require(script.Parent.selectTryOnItems)

local function selectHasMakeupTryOn(p): boolean
	for _, v in selectTryOnItems(p) do
		if v.selectedInTryOnManager and v.itemType and isMakeupAssetType(v.itemSubType) then
			return true
		end
	end

	return false
end

return selectHasMakeupTryOn
