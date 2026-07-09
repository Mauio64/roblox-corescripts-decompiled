local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local AvatarExperienceFlags = require(AvatarExperienceCommonParent.AvatarExperienceFlags)
local isMakeupAssetType = require(AvatarExperienceCommon.Utils.isMakeupAssetType)
local selectTryOnItems = require(script.Parent.selectTryOnItems)
local FFlagAXMakeupEquipping = AvatarExperienceFlags.FFlagAXMakeupEquipping

local function selectHasMakeupTryOn(p1) -- line: 14
	-- upvalues: FFlagAXMakeupEquipping (copy), selectTryOnItems (copy), isMakeupAssetType (copy)
	if not FFlagAXMakeupEquipping then
		return false
	end

	for _, v10 in selectTryOnItems(p1) do
		if v10.selectedInTryOnManager and v10.itemType and isMakeupAssetType(v10.itemSubType) then
			return true
		end
	end

	return false
end

return selectHasMakeupTryOn
