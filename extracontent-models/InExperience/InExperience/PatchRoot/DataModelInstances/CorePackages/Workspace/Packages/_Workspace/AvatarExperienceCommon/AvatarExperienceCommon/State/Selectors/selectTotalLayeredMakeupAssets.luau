local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local isMakeupAssetType = require(AvatarExperienceCommon.Utils.isMakeupAssetType)
local selectTryOnItems = require(script.Parent.selectTryOnItems)
local selectEquippedLayeredMakeupAssets = require(script.Parent.selectEquippedLayeredMakeupAssets)

local function selectTotalLayeredMakeupAssets(p)
	local v = #selectEquippedLayeredMakeupAssets(p)
	local count = 0

	for _, v2 in selectTryOnItems(p) do
		if v2.selectedInTryOnManager and v2.itemType and isMakeupAssetType(v2.itemSubType) then
			count += 1
		end
	end

	return v + count
end

return selectTotalLayeredMakeupAssets
