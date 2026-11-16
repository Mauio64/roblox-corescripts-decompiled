local GameTile = script:FindFirstAncestor("GameTile")

local formatExperienceIcon = require(GameTile.formatExperienceIcon)
local formatExperienceThumbnail = require(GameTile.formatExperienceThumbnail)
local resolveWideAssetId = require(GameTile.resolveWideAssetId)

local function resolveGameTileThumbnailUri(data)
	if data.useGridTile then
		local wideAssetId = resolveWideAssetId(data.perEntryWideAssetId, data.game, data.topicId)

		if wideAssetId or data.placeId then
			return formatExperienceThumbnail(wideAssetId, data.placeId, data.isEmphasized)
		end

		return nil
	elseif data.universeId then
		return formatExperienceIcon(data.iconUrl, data.universeId)
	else
		return data.iconUrl
	end
end

return resolveGameTileThumbnailUri
