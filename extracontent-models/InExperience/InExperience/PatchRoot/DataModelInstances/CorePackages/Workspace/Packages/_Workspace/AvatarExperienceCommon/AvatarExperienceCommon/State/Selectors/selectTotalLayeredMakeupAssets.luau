local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local AvatarExperienceFlags = require(AvatarExperienceCommonParent.AvatarExperienceFlags)
local isMakeupAssetType = require(AvatarExperienceCommon.Utils.isMakeupAssetType)
local selectTryOnItems = require(script.Parent.selectTryOnItems)
local selectEquippedLayeredMakeupAssets = require(script.Parent.selectEquippedLayeredMakeupAssets)
local FFlagAXMakeupEquipping = AvatarExperienceFlags.FFlagAXMakeupEquipping

local function selectTotalLayeredMakeupAssets(p1) -- line: 15
	-- upvalues: FFlagAXMakeupEquipping (copy), selectEquippedLayeredMakeupAssets (copy), selectTryOnItems (copy), isMakeupAssetType (copy)
	if not FFlagAXMakeupEquipping then
		return 0
	end

	local v10 = #selectEquippedLayeredMakeupAssets(p1)
	local n1 = 0

	for _, v13 in selectTryOnItems(p1) do
		if v13.selectedInTryOnManager and v13.itemType and isMakeupAssetType(v13.itemSubType) then
			n1 += 1
		end
	end

	return v10 + n1
end

return selectTotalLayeredMakeupAssets
