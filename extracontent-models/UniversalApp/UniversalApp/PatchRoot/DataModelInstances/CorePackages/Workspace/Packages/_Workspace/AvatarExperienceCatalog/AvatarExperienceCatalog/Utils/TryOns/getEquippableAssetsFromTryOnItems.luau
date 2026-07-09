local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local AvatarExperienceCommon = require(Parent.AvatarExperienceCommon)
local FFlagParseHeadShapeFromAPIResponse = require(Parent.AvatarExperienceFlags).FFlagParseHeadShapeFromAPIResponse
local Constants = AvatarExperienceCommon.Constants

local function getEquippableAssetsFromTryOnItems(t1: {[any]: any}) -- line: 16
	-- upvalues: Constants (copy), FFlagParseHeadShapeFromAPIResponse (copy)
	table.sort(t1, function(p1, p2) -- line: 29
		return tonumber(p1.itemRecency) < tonumber(p2.itemRecency)
	end)

	local t2 = {}

	for _, v9 in t1 do
		if v9.itemId ~= Constants.AVATAR_BLOCKY_DEFAULT_BUNDLE_ID then
			if v9.itemType == Enum.AvatarItemType.Asset.Name then
				table.insert(t2, {
					assetId = v9.itemId,
					assetTypeId = v9.itemSubType,
					order = v9.order
				})
			elseif v9.itemType == Enum.AvatarItemType.Bundle.Name then
				for v10, v11 in v9.bundleInfo do
					table.insert(t2, {
						assetId = v10,
						assetTypeId = v11.assetType,
						headShape = if not FFlagParseHeadShapeFromAPIResponse or not v11 then nil else v11.headShape
					})
				end
			end
		end
	end

	return t2
end

return getEquippableAssetsFromTryOnItems
