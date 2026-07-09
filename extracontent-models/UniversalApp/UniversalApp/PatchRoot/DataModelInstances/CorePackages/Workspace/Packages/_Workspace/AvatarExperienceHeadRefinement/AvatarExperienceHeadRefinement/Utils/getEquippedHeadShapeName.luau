local AvatarExperienceHeadRefinement = script:FindFirstAncestor("AvatarExperienceHeadRefinement")
local AvatarExperienceHeadRefinementParent = AvatarExperienceHeadRefinement.Parent
local getEquippedAssetIdsByAssetTypeId = require(AvatarExperienceHeadRefinement.Utils.getEquippedAssetIdsByAssetTypeId)

require(AvatarExperienceHeadRefinement.Enums.HeadShape)

local HeadShapePropertiesByAssetId = require(AvatarExperienceHeadRefinement.Enums.HeadShapePropertiesByAssetId)
local FFlagDynamicHeadsMigration = require(AvatarExperienceHeadRefinementParent.AvatarExperienceFlags).FFlagDynamicHeadsMigration
local Constants = require(AvatarExperienceHeadRefinementParent.AvatarExperienceCommon).Constants

local function getEquippedHeadShapeName(p1, p2) -- line: 13
	-- upvalues: getEquippedAssetIdsByAssetTypeId (copy), HeadShapePropertiesByAssetId (copy), FFlagDynamicHeadsMigration (copy), Constants (copy)
	local v10 = getEquippedAssetIdsByAssetTypeId(p1, p2)[1]

	if v10 then
		return (HeadShapePropertiesByAssetId[tostring(v10)] or {
			name = nil
		}).name
	end

	if FFlagDynamicHeadsMigration and p1 then
		local DynamicHead = Constants.ASSET_TYPE_NAME_TO_ID_STRING.DynamicHead

		if DynamicHead then
			local v12 = p1[DynamicHead]

			if v12 then
				for _, v14 in v12 do
					if v14 and v14.headShape then
						return v14.headShape
					end
				end
			end
		end
	end

	return nil
end

return getEquippedHeadShapeName
