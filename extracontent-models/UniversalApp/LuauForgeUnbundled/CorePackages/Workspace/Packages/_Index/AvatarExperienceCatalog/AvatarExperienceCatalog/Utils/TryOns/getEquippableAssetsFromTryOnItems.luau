local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local fFlagParseHeadShapeFromAPIResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagParseHeadShapeFromAPIResponse

local constants = AvatarExperienceCommon.Constants

local function getEquippableAssetsFromTryOnItems(list)
	table.sort(list, function(a, b): boolean
		return tonumber(a.itemRecency) < tonumber(b.itemRecency)
	end)

	local equippableAssets = {}

	for k, item in list do
		if item.itemId == constants.AVATAR_BLOCKY_DEFAULT_BUNDLE_ID then
			continue
		end

		if item.itemType == Enum.AvatarItemType.Asset.Name then
			table.insert(equippableAssets, {
				assetId = item.itemId,
				assetTypeId = item.itemSubType,
				order = item.order
			})
		elseif item.itemType == Enum.AvatarItemType.Bundle.Name then
			for k2, v5 in item.bundleInfo do
				local v6 = { assetId = k2, assetTypeId = v5.assetType, headShape = 0 }
				local v7 = if fFlagParseHeadShapeFromAPIResponse and v5 then v5.headShape else nil
				v6.headShape = v7
				table.insert(equippableAssets, v6)
			end
		end
	end

	return equippableAssets
end

return getEquippableAssetsFromTryOnItems
