local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagParseHeadShapeFromAPIResponse = AvatarExperienceFlags.FFlagParseHeadShapeFromAPIResponse

local Constants = AvatarExperienceCommon.Constants

local function getEquippableAssetsFromTryOnItems(list)
	table.sort(list, function(a, b): boolean
		return tonumber(a.itemRecency) < tonumber(b.itemRecency)
	end)

	local equippableAssets = {}

	for _, item in list do
		if item.itemId == Constants.AVATAR_BLOCKY_DEFAULT_BUNDLE_ID then
			continue
		end

		if item.itemType == Enum.AvatarItemType.Asset.Name then
			table.insert(equippableAssets, {
				assetId = item.itemId,
				assetTypeId = item.itemSubType,
				order = item.order
			})
		elseif item.itemType == Enum.AvatarItemType.Bundle.Name then
			for k, v in item.bundleInfo do
				local v2 = { assetId = k, assetTypeId = v.assetType, headShape = 0 }
				local headShape

				if FFlagParseHeadShapeFromAPIResponse and v then
					headShape = v.headShape
				end

				v2.headShape = headShape
				table.insert(equippableAssets, v2)
			end
		end
	end

	return equippableAssets
end

return getEquippableAssetsFromTryOnItems
