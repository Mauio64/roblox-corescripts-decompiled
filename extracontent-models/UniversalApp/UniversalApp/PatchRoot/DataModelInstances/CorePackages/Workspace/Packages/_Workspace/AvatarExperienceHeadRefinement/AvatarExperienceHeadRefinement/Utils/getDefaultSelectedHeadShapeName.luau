local AvatarExperienceHeadRefinement = script:FindFirstAncestor("AvatarExperienceHeadRefinement")
local getEquippedAssetIdsByAssetTypeId = require(AvatarExperienceHeadRefinement.Utils.getEquippedAssetIdsByAssetTypeId)
local AvatarExperienceHeadRefinementParent = AvatarExperienceHeadRefinement.Parent
local AvatarExperienceFlags = require(AvatarExperienceHeadRefinementParent.AvatarExperienceFlags)
local HeadShape = require(AvatarExperienceHeadRefinement.Enums.HeadShape)
local FFlagDynamicHeadsMigration = AvatarExperienceFlags.FFlagDynamicHeadsMigration

local function isClassicFaceEquipped(p1) -- line: 9
	-- upvalues: getEquippedAssetIdsByAssetTypeId (copy)
	return #getEquippedAssetIdsByAssetTypeId(p1, (tostring(Enum.AssetType.Face.Value))) > 0
end
local function getDefaultSelectedHeadShapeName(t1: {[any]: any}) -- line: 15
	-- upvalues: getEquippedAssetIdsByAssetTypeId (copy), FFlagDynamicHeadsMigration (copy), HeadShape (copy)
	local isTryingOnItems = t1.isTryingOnItems
	local equippedAssets = t1.equippedAssets
	local v13 = if not (#getEquippedAssetIdsByAssetTypeId(equippedAssets, (tostring(Enum.AssetType.Face.Value))) > 0) then nil else t1.defaultHeadShapeName

	if isTryingOnItems and FFlagDynamicHeadsMigration then
		return t1.lastTryOnHeadShapeName or (t1.defaultHeadShapeName or (t1.equippedHeadShapeName or v13))
	end

	if isTryingOnItems then
		return t1.lastTryOnHeadShapeName or (t1.equippedHeadShapeName or v13)
	end

	return t1.equippedHeadShapeName or HeadShape.Default
end

return getDefaultSelectedHeadShapeName
