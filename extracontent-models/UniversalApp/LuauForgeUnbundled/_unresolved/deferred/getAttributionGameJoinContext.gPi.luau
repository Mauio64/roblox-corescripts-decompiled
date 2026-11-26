local module = require("@luauforge/bundled/dTT")
local itemTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarSwitcher/AvatarExperienceModel").Enums.ItemTypeEnum
local mutedError = require("@luauforge/deferred/gPj").mutedError

local defineFastFlag = game:DefineFastFlag("AXItemInfoListUnknownItemSubType", false)

local ASSET_TYPE_ID_STRING_TO_NAME = module.Constants.ASSET_TYPE_ID_STRING_TO_NAME

local function getAttributionGameJoinContext(p2, p3, p4, p5)
	if p5 then
		return {
			outfitId = p5.outfitId,
			itemType = Enum.AvatarItemType.Bundle,
			joinSource = Enum.JoinSource.CreatedItemAttribution
		}
	end

	if defineFastFlag and p2 == itemTypeEnum.Asset and p4 and not ASSET_TYPE_ID_STRING_TO_NAME[p4] then
		mutedError(`Unknown asset type id string in getAttributionGameJoinContext: {p4}`)
	end

	local v6 = if p2 then Enum.AvatarItemType[p2] else nil
	local v7 = if p2 == itemTypeEnum.Asset and p4 and (not defineFastFlag or ASSET_TYPE_ID_STRING_TO_NAME[p4]) then Enum.AvatarAssetType[ASSET_TYPE_ID_STRING_TO_NAME[p4]] else nil
	return {
		assetId = p3,
		itemType = v6,
		assetType = v7,
		joinSource = Enum.JoinSource.CreatedItemAttribution
	}
end

return getAttributionGameJoinContext
